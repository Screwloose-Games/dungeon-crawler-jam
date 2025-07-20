## Manages the spatial grid system for a [Battle] on a [Battlefield]. [br]
## Combines terrain information from the [Battlefield] with unit and object placement. [br]
## Used by [Commander] units to determine valid positions and execute [UnitAction] commands. [br]
## Maintains the state of each [gridCell] including any occupying [Unit] and any [TileEffect].
class_name BattleGrid
extends Resource

## Dictionary mapping grid coordinates to their corresponding cell data and occupants
@export var cells: Dictionary[Vector2i, BattleGridCell]

var teams: Array[Team]

## Only to be used for instantiating the TileMapLayer
#var battlefield_scene: PackedScene
var battlefield: Battlefield

## Store graph information
var fly_navigation: NavigationLayer
var walk_navigation: NavigationLayer


func _init(
	battlefield: Battlefield = null, layout: GridObjectLayout = null, teams: Array[Team] = []
):
	print("Loading battlegrid")
	self.teams = teams
	_load_battlefield_tiles(battlefield)
	_load_grid_object_layout_tiles(layout)
	_construct_navigation()
	print("%d cells loaded" % len(cells))


func get_cell(tile_position: Vector2i) -> BattleGridCell:
	if not cells.has(tile_position):
		return
	return cells[tile_position]


func is_cell_movable(cell_pos: Vector2i, movement_method: Movement.MovementMethod):
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
			return movement_method == Movement.MovementMethod.FLY


func try_set_unit(cell_pos: Vector2i, unit: Unit) -> bool:
	if not is_cell_movable(cell_pos, unit.movement.method):
		return false
	cells[cell_pos].unit = unit
	return true


func force_set_unit(cell_pos: Vector2i, unit: Unit) -> bool:
	if not cells.has(cell_pos):
		return false
	cells[cell_pos].unit = unit
	return true


func cell_clicked(commander: Commander, tile_position: Vector2i):
	if not cells.has(tile_position):
		return

	var cell = cells[tile_position]
	if not cell.unit:
		# TODO: Selected cells?
		return

	commander.select_unit(cell.unit)


func hover_cell(commander: Commander, tile_position: Vector2i):
	if not cells.has(tile_position):
		return

	var cell = cells[tile_position]
	commander.hover_cell(cell)


func _load_battlefield_tiles(battlefield: Battlefield):
	if not battlefield:
		return
	var tiles := battlefield.get_tile_data()
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


func _create_or_get_cell(pos: Vector2i) -> BattleGridCell:
	if not cells.has(pos):
		cells[pos] = BattleGridCell.new(pos)
	return cells[pos]


func _construct_navigation():
	var keys = cells.keys()
	if len(keys) == 0:
		return

	walk_navigation = NavigationLayer.new(cells, [BattleGridCell.TileType.GROUND])
	fly_navigation = NavigationLayer.new(
		cells, [BattleGridCell.TileType.GROUND, BattleGridCell.TileType.PIT]
	)


func get_movement_path(
	from: BattleGridCell, to: BattleGridCell, movement_method: Movement.MovementMethod
) -> MovementPath:
	match movement_method:
		Movement.MovementMethod.WALK:
			return walk_navigation.get_movement_path(from.position, to.position)
		Movement.MovementMethod.FLY:
			return fly_navigation.get_movement_path(from.position, to.position)
		_:
			assert(false, "MovementMethod not implemented: %s" % movement_method)
			return null
