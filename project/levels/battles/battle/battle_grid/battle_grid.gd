## Manages the spatial grid system for a [Battle] on a [Battlefield]. [br]
## Combines terrain information from the [Battlefield] with unit and object placement. [br]
## Used by [Commander] units to determine valid positions and execute [UnitAction] commands. [br]
## Maintains the state of each [gridCell] including any occupying [Unit] and any [TileEffect].
class_name BattleGrid
extends Resource

static var cardinal_directions: Array[Vector2i] = [
	Vector2i(1, 0),
	Vector2i(0, 1),
	Vector2i(-1, 0),
	Vector2i(0, -1),
]

static var diagonal_directions: Array[Vector2i] = [
	Vector2i(1, 1),
	Vector2i(-1, 1),
	Vector2i(-1, -1),
	Vector2i(1, -1),
]

## Dictionary mapping grid coordinates to their corresponding cell data and occupants
@export var cells: Dictionary[Vector2i, BattleGridCell]

var teams: Array[Team]
var battlefield: Battlefield

## Store graph information
var air_navigation: NavigationLayer
var ground_navigation: NavigationLayer


func _init(
	battlefield: Battlefield = null, layout: GridObjectLayout = null, teams: Array[Team] = []
):
	print("Loading battlegrid")
	self.teams = teams
	_load_battlefield_tiles(battlefield)
	_load_grid_object_layout_tiles(layout)
	_construct_navigation()
	print("%d cells loaded" % len(cells))


## Get the normalized direction vector, snapped to the four cardinal directions
## If [param allow_diagonals] is set, then the four diagonal directions are allowed
static func get_snapped_direction(position: Vector2, allow_diagonals: bool) -> Vector2:
	var directions: Array[Vector2i] = cardinal_directions
	if allow_diagonals:
		directions.append_array(diagonal_directions)

	var best_similarity := 0.0
	var best_direction := Vector2.ZERO
	for dir in directions:
		var normalized_dir = Vector2(dir).normalized()
		var similarity = normalized_dir.dot(position)
		if similarity > best_similarity:
			best_similarity = similarity
			best_direction = normalized_dir

	return best_direction


func get_cell(tile_position: Vector2i) -> BattleGridCell:
	if not cells.has(tile_position):
		return
	return cells[tile_position]


func is_cell_movable_to(cell_pos: Vector2i, movement_method: Movement.Method):
	if not cells.has(cell_pos):
		return false
	var cell = cells[cell_pos]
	if cell.unit != null:
		return false
	match cell.type:
		BattleGridCell.TileType.WALL:
			return false
		BattleGridCell.TileType.GROUND:
			return true
		BattleGridCell.TileType.PIT:
			return movement_method == Movement.Method.FLY


func _load_battlefield_tiles(battlefield: Battlefield):
	if not battlefield:
		return
	var tiles: Dictionary[Vector2i, BattleGridCell.TileType] = battlefield.get_tile_data()
	for tile_pos in tiles.keys():
		var cell = _create_or_get_cell(tile_pos)
		cell.type = tiles[tile_pos]


func _load_grid_object_layout_tiles(layout: GridObjectLayout):
	if not layout:
		return
	var tiles := layout.get_tile_data()
	for tile_pos in tiles.keys():
		var layout_tile = tiles[tile_pos]
		var cell = _create_or_get_cell(tile_pos)
		if layout_tile.unit:
			cell.unit = layout_tile.unit.duplicate()
			cell.unit.team = teams[layout_tile.team_index]
		cell.effects = layout_tile.effect


func _construct_navigation():
	var keys = cells.keys()
	if len(keys) == 0:
		return

	ground_navigation = NavigationLayer.new(cells, [BattleGridCell.TileType.GROUND])
	air_navigation = NavigationLayer.new(
		cells, [BattleGridCell.TileType.GROUND, BattleGridCell.TileType.PIT]
	)


func get_movement_path(
	from: BattleGridCell, to: BattleGridCell, move_method: Movement.Method
) -> MovementPath:
	var path: MovementPath = null

	match move_method:
		Movement.Method.WALK:
			path = ground_navigation.get_movement_path(from.position, to.position)
		Movement.Method.FLY:
			path = air_navigation.get_movement_path(from.position, to.position)
		_:
			assert(false, "MovementMethod not implemented: %s" % move_method)
			return null
	if not path:
		return null

	path.move_method = move_method
	return path


func get_adjacent_cells(cell: BattleGridCell) -> Array[BattleGridCell]:
	var coords = cell.position
	var adjacent_cells: Array[BattleGridCell] = []

	var adjacent_positions = [
		coords + Vector2i(0, 1),
		coords + Vector2i(0, -1),
		coords + Vector2i(1, 0),
		coords + Vector2i(-1, 0)
	]

	for pos in adjacent_positions:
		var adjacent_cell = get_cell(pos)
		if adjacent_cell:
			adjacent_cells.append(adjacent_cell)

	return adjacent_cells


func get_cells_within_distance(
	from_cell: BattleGridCell,
	distance: int,
	movement_method: Movement.Method,
	cell_check: Callable,
) -> Array[BattleGridCell]:
	match movement_method:
		Movement.Method.WALK:
			return ground_navigation.get_cells_within_distance(from_cell, distance, cell_check)
		Movement.Method.FLY:
			return air_navigation.get_cells_within_distance(from_cell, distance, cell_check)
	return []


func try_set_unit(cell_pos: Vector2i, unit: Unit) -> bool:
	if not is_cell_movable_to(cell_pos, unit.movement.method):
		return false
	cells[cell_pos].unit = unit
	return true


func force_set_unit(cell_pos: Vector2i, unit: Unit) -> bool:
	if not cells.has(cell_pos):
		return false
	cells[cell_pos].unit = unit
	return true


func get_cells() -> Array[BattleGridCell]:
	return cells.values()


func _create_or_get_cell(pos: Vector2i) -> BattleGridCell:
	if not cells.has(pos):
		cells[pos] = BattleGridCell.new(self, pos)
	return cells[pos]


func get_units() -> Array[Unit]:
	var units: Array[Unit] = []
	var temp_units = (
		cells
		.values()
		.filter(func(cell: BattleGridCell): return cell.unit != null)
		.map(func(cell: BattleGridCell): return cell.unit)
	)
	units.append_array(temp_units)
	return units
