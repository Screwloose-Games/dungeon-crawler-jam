@tool
class_name BattlefieldNode
extends Node2D

const TILE_DATA_LAYER = "TileType"
const TIME_BETWEEN_SYNCS = 10

@export_custom(PROPERTY_HINT_NONE, "", 2)
var tile_data: Dictionary[Vector2i, BattleGridCell.TileType]
@export var battlefield: Battlefield
@export_tool_button("Sync TileData") var sync_tile_data_tool_button = _on_tile_map_changed

var time_since_sync: float = 0

@onready var floors: TileMapLayer = $Floors
@onready var paths: TileMapLayer = $Paths

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		time_since_sync += delta
		if time_since_sync >= TIME_BETWEEN_SYNCS:
			time_since_sync = 0
			_on_tile_map_changed()


func _ready() -> void:
	initialize()
	floors.changed.connect(_on_tile_map_changed)
	GlobalSignalBus.action_preview_requested.connect(_on_action_preview_requested)


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


func _on_action_preview_requested(preview_data: ActionPreviewData) -> void:
	_display_path(preview_data.path_tiles)


func _display_path(path: Dictionary[Vector2i, MovementPath.Orientation]) -> void:
	_clear_previous_path()
	for path_segment in path.keys():
		_draw_path_orientation(path_segment, path[path_segment])


func _draw_path_orientation(tile_position: Vector2i, _orientation: MovementPath.Orientation) -> void:
	paths.set_cell(tile_position, 0, Vector2i(2, 1), 0)


func _clear_previous_path() -> void:
	for used_cell in paths.get_used_cells():
		paths.erase_cell(used_cell)
