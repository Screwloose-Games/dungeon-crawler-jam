extends Control

##Audio
@export var navigate_sound: AudioStream
@export var open_sound: AudioStream
@export var close_sound: AudioStream
@export var hover_time: float

@onready var hover_player: AudioStreamPlayer = $hover_player
var time_since_last_hover = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_open():
	SoundManager.play_ui_sound(open_sound)


func _on_close():
	SoundManager.play_ui_sound(close_sound)


func _on_hover():
	var current_time = Time.get_ticks_msec()
	if (current_time - time_since_last_hover) >= hover_time:
		hover_player.stream = navigate_sound
		hover_player.play(0.0)
		time_since_last_hover = current_time


func _on_slider_value_changed(value):
	SoundManager.play_ui_sound(navigate_sound)


func _on_v_button_list_focus_entered() -> void:
	SFXController.menu_hover()
