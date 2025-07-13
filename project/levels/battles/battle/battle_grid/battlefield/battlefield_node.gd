@tool
class_name BattlefieldNode
extends Node2D

@export_custom(PROPERTY_HINT_NONE, "", 2) var tile_data: Dictionary[Vector2i, Battlefield.TileType]
@onready var floors: TileMapLayer = $Floors


func _ready() -> void:
	floors.changed.connect(_on_tile_map_changed)


func _on_tile_map_changed():
	tile_data = {}
	for cell_pos in floors.get_used_cells():
		var data = floors.get_cell_tile_data(cell_pos)
		convert_tile_data(cell_pos, data)


func convert_tile_data(pos: Vector2i, data: TileData):
	var tile_type = data.get_custom_data("TileType") as Battlefield.TileType
	tile_data[pos] = tile_type
