extends MarginContainer

# Just have hp/ap count hardcoded for now
const hp_segments: int = 30
const hp_size: int = 3
const hp_first_offset: int = 1 # First and last HP segments are 1 pixel larger
const ap_segments: int = 10
const ap_size: int = 10

var hp_width: int
var ap_width: int
var current_unit: Unit

@onready var character_portrait: TextureRect = $CharacterPaneBack/CharacterPortrait
@onready var hp_clip_area: Control = $CharacterPaneBack/HPClipArea
@onready var ap_clip_area: Control = $CharacterPaneBack/AP/APClipArea
@onready var character_name: RichTextLabel = $CharacterPaneBack/CharaterNameMargin/CharacterName
@onready var ap_usage: PanelContainer = $CharacterPaneBack/AP/APClipArea/APUsage


func _ready() -> void:
	GlobalSignalBus.action_preview_requested.connect(_on_action_preview_requested)
	GlobalSignalBus.action_preview_cancelled.connect(_on_action_preview_cancelled)


func _on_player_hud_unit_selected(unit: Unit) -> void:
	if not unit.changed.is_connected(_on_unit_changed):
		unit.changed.connect(_on_unit_changed)
		unit.action_points_changed.connect(_on_unit_changed)
	current_unit = unit
	_on_unit_changed()


func _on_unit_changed():
	_set_hp_bar_for_unit(current_unit)
	_set_ap_bar_for_unit(current_unit)
	character_name.text = current_unit.name
	character_portrait.texture = current_unit.portrait


func _set_hp_bar_for_unit(unit: Unit):
	var hp_bar_width = hp_first_offset + unit.health_points * hp_size
	var hp_bar_height = hp_clip_area.get_rect().size.y
	if unit.health_points == 0:
		hp_bar_width = 0
	hp_clip_area.set_size(Vector2(hp_bar_width, hp_bar_height))


func _set_ap_bar_for_unit(unit: Unit):
	var ap_bar_width = unit.action_points_current * ap_size
	ap_clip_area.offset_right = ap_bar_width


func _show_ap_cost(cost: int):
	var width: int = cost * ap_size
	ap_usage.offset_left = - width


func _on_action_preview_requested(preview: ActionPreviewData):
	_show_ap_cost(preview.action_point_cost)


func _on_action_preview_cancelled(_preview: ActionPreviewData):
	_show_ap_cost(0)
