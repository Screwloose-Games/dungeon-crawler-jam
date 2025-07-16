## Manages the spatial grid system for a [Battle] on a [Battlefield]. [br]
## Combines terrain information from the [Battlefield] with unit and object placement. [br]
## Used by [Commander] units to determine valid positions and execute [UnitAction] commands. [br]
## Maintains the state of each [gridCell] including any occupying [Unit] and any [TileEffect].
class_name BattleGrid
extends Resource

## Dictionary mapping grid coordinates to their corresponding cell data and occupants
@export var cells: Dictionary[Vector2i, BattleGridCell]

## Only to be used for instantiating the TileMapLayer
var battlefield_scene: PackedScene


func load(battlefield: Battlefield, layout: GridObjectLayout):
	print("Loading battlegrid")
	battlefield_scene = battlefield.scene
	_load_battlefield_tiles(battlefield)
	_load_grid_object_layout_tiles(layout)
	print("%d cells loaded" % len(cells))


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


func _load_battlefield_tiles(battlefield: Battlefield):
	var tiles := battlefield.get_tile_data()
	for tile_pos in tiles.keys():
		var cell = _create_or_get_cell(tile_pos)
		cell.type = tiles[tile_pos]


func _load_grid_object_layout_tiles(layout: GridObjectLayout):
	var tiles := layout.get_tile_data()
	for tile_pos in tiles.keys():
		var layout_tile = tiles[tile_pos]
		var cell = _create_or_get_cell(tile_pos)
		cell.unit = layout_tile.unit
		cell.effects = layout_tile.effect


func _create_or_get_cell(pos: Vector2i):
	if not cells.has(pos):
		cells[pos] = BattleGridCell.new()
	return cells[pos]
