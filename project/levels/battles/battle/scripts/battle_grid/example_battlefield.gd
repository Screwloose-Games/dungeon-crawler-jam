@tool
class_name BattlefieldNode
extends Node2D

@export_custom(PROPERTY_HINT_NONE, "", 2) var cell_data: Array[Vector2i]
@onready var tile_map_layer: TileMapLayer = %TileMapLayer


func _ready() -> void:
	tile_map_layer.changed.connect(_on_tile_map_changed)


func _on_tile_map_changed():
	cell_data = get_cells()


func get_cells():
	print("Got cells:", tile_map_layer.get_used_cells())
	return tile_map_layer.get_used_cells()
