class_name BattleGrid
extends Resource

signal grid_cells_loaded()

var cells: Dictionary[Vector2i, BattleGridCell]
## Only to be used for instantiating the TileMapLayer
var battlefield_scene: PackedScene

func load(battlefield: Battlefield, layout: GridObjectLayout):
	print("Loading battlegrid")
	battlefield_scene = battlefield.scene
	_load_battlefield_tiles(battlefield)
	_load_grid_object_layout_tiles(layout)
	grid_cells_loaded.emit()
	print("%d cells loaded" % len(cells))


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
