@tool
class_name BattlefieldNode
extends Node2D

const TILE_DATA_LAYER = "TileType"

@export_custom(PROPERTY_HINT_NONE, "", 2)
var tile_data: Dictionary[Vector2i, BattleGridCell.TileType]
@export var battlefield: Battlefield
@onready var floors: TileMapLayer = $Floors


func _ready() -> void:
	initialize()
	floors.changed.connect(_on_tile_map_changed)


func initialize():
	if battlefield:
		floors.tile_set = battlefield.tile_set
		floors.tile_map_data = battlefield.tile_map_data


func _on_tile_map_changed():
	if battlefield:
		battlefield.tile_data = {}
		for cell_pos in floors.get_used_cells():
			var data = floors.get_cell_tile_data(cell_pos)
			convert_tile_data(cell_pos, data)
			battlefield.tile_map_data = floors.tile_map_data
			battlefield.tile_set = floors.tile_set


func convert_tile_data(pos: Vector2i, data: TileData):
	var tile_type = data.get_custom_data(TILE_DATA_LAYER) as BattleGridCell.TileType
	battlefield.tile_data[pos] = tile_type
