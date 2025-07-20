@tool
class_name BattlefieldNode
extends Node2D

const TILE_DATA_LAYER = "TileType"
const TIME_BETWEEN_SYNCS = 10

@export_custom(PROPERTY_HINT_NONE, "", 2)
var tile_data: Dictionary[Vector2i, BattleGridCell.TileType]
@export var battlefield: Battlefield
@export_tool_button("Sync TileData") var sync_tile_data_tool_button = _on_tile_map_changed
@onready var floors: TileMapLayer = $Floors
var time_since_sync: float = 0

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		time_since_sync += delta
		if time_since_sync >= TIME_BETWEEN_SYNCS:
			time_since_sync = 0
			_on_tile_map_changed()


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
			if not data:
				continue
			convert_tile_data(cell_pos, data)
			battlefield.tile_map_data = floors.tile_map_data
			battlefield.tile_set = floors.tile_set


func convert_tile_data(pos: Vector2i, data: TileData):
	var tile_type = data.get_custom_data(TILE_DATA_LAYER) as BattleGridCell.TileType
	battlefield.tile_data[pos] = tile_type
