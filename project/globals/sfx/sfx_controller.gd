extends Node

@export var pause_sound: AudioStream
@export var unpause_sound: AudioStream

@export var select_sound: AudioStreamRandomizer
@export var open_action_menu_sound: AudioStream
@export var end_turn_sound: AudioStream

var is_action_panel_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.game_paused.connect(_start_pause)
	GlobalSignalBus.game_unpaused.connect(_end_pause)
	GlobalSignalBus.battle_turn_ended.connect(_on_end_turn)
	GlobalSignalBus.player_selected_unit.connect(_player_selected_unit)
	GlobalSignalBus.action_panel_opened.connect(_set_action_panel_open)

func _start_pause():
	SoundManager.play_ui_sound(pause_sound)

func _end_pause():
	SoundManager.play_ui_sound(unpause_sound)

func _on_end_turn(_team: Team):
	SoundManager.play_ui_sound(end_turn_sound)

func _player_selected_unit(unit: Unit):
	select()

func _set_action_panel_open(is_open: bool):
	if is_open:
		SoundManager.play_ui_sound(open_action_menu_sound)
	else:
		SoundManager.play_ui_sound(select_sound)

func select() -> void:
	var player = SoundManager.play_ui_sound(select_sound)
	player.volume_linear = 0.8
