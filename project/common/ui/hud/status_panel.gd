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
@onready var ap_clip_area: Control = $CharacterPaneBack/APClipArea
@onready var character_name: RichTextLabel = $CharacterPaneBack/CharaterNameMargin/CharacterName


func _on_player_hud_unit_selected(unit: Unit) -> void:
	if not unit.changed.is_connected(_on_unit_changed):
		unit.changed.connect(_on_unit_changed)
	current_unit = unit
	_on_unit_changed()


func _on_player_hud_unit_unselected(unit: Unit) -> void:
	pass
	# if unit.changed.is_connected(_on_unit_changed):
	# 	unit.changed.disconnect(_on_unit_changed)


func _on_unit_changed():
	set_hp_bar(current_unit)
	set_ap_bar(current_unit)


func set_hp_bar(unit: Unit):
	var hp_bar_width = hp_first_offset + unit.health_points * hp_size
	var hp_bar_height = hp_clip_area.get_rect().size.y
	if unit.health_points == 0:
		hp_bar_width = 0
	hp_clip_area.set_size(Vector2(hp_bar_width, hp_bar_height))


func set_ap_bar(unit: Unit):
	var ap_bar_width = unit.action_points_current * ap_size
	var ap_bar_height = ap_clip_area.get_rect().size.y
	ap_clip_area.set_size(Vector2(ap_bar_width, ap_bar_height))
