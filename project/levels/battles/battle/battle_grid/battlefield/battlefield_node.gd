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

@onready var floor_tile_map: TileMapLayer = $Floors
@onready var path_tile_map: TileMapLayer = $Paths
@onready var highlight_tile_map: TileMapLayer = $Highlights

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		time_since_sync += delta
		if time_since_sync >= TIME_BETWEEN_SYNCS:
			time_since_sync = 0
			_on_tile_map_changed()


func _ready() -> void:
	floor_tile_map.changed.connect(_on_tile_map_changed)
	if Engine.is_editor_hint():
		return


func initialize(battlefield: Battlefield):
	if battlefield:
		floor_tile_map.tile_set = battlefield.tile_set
		floor_tile_map.tile_map_data = battlefield.tile_map_data
	GlobalSignalBus.action_preview_requested.connect(_on_action_preview_requested)
	GlobalSignalBus.action_preview_cancelled.connect(_on_action_preview_cancelled)


func _on_tile_map_changed():
	if battlefield:
		battlefield.tile_data = {}
		for cell_pos in floor_tile_map.get_used_cells():
			var data = floor_tile_map.get_cell_tile_data(cell_pos)
			if not data:
				continue
			convert_tile_data(cell_pos, data)
			battlefield.tile_map_data = floor_tile_map.tile_map_data
			battlefield.tile_set = floor_tile_map.tile_set


func convert_tile_data(pos: Vector2i, data: TileData):
	var tile_type = data.get_custom_data(TILE_DATA_LAYER) as BattleGridCell.TileType
	battlefield.tile_data[pos] = tile_type


func _on_action_preview_requested(preview_data: ActionPreviewData) -> void:
	_display_path(preview_data.path_tiles)
	_display_highlights(preview_data.highlighted_cells)


func _display_highlights(highlights: Dictionary[Vector2i, CellHighlight]):
	for cell_position in highlights.keys():
		var highlight = highlights[cell_position]
		highlight.set_on_tile_map(highlight_tile_map, cell_position)


func _on_action_preview_cancelled(_preview_data: ActionPreviewData):
	_clear_previous_path()
	_clear_previous_highlights()


func _display_path(path: Dictionary[Vector2i, MovementPath.Orientation]) -> void:
	for path_segment in path.keys():
		_draw_path_orientation(path_segment, path[path_segment])


func _draw_path_orientation(tile_position: Vector2i, orientation: MovementPath.Orientation) -> void:
	assert(PathTileData.orientation_lookup.has(orientation), "Unexpected orientation: %s" % orientation)
	var path_data = PathTileData.orientation_lookup[orientation]
	path_tile_map.set_cell(
		tile_position,
		path_data.atlas_source,
		path_data.atlas_position,
		path_data.alternate_tile
	)


func _clear_previous_highlights():
	for used_cell in highlight_tile_map.get_used_cells():
		highlight_tile_map.erase_cell(used_cell)


func _clear_previous_path() -> void:
	for used_cell in path_tile_map.get_used_cells():
		path_tile_map.erase_cell(used_cell)
