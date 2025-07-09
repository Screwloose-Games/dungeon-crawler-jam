extends Node

@export var pause_sound: AudioStream
@export var unpause_sound: AudioStream
@export var coin_collect_sound: AudioStream

var coin_players: Array[AudioStreamPlayer]
var coin_index: int = 0

@onready var coin_player_0: AudioStreamPlayer = $coin_player_0
@onready var coin_player_1: AudioStreamPlayer = $coin_player_1
@onready var coin_player_2: AudioStreamPlayer = $coin_player_2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.game_paused.connect(_start_pause)
	GlobalSignalBus.game_unpaused.connect(_end_pause)
	GlobalSignalBus.coin_collected.connect(_on_collect_coin)
	coin_player_0.stream = coin_collect_sound
	coin_player_1.stream = coin_collect_sound
	coin_player_2.stream = coin_collect_sound
	coin_players.append(coin_player_0)
	coin_players.append(coin_player_1)
	coin_players.append(coin_player_2)


func _start_pause():
	SoundManager.play_ui_sound(pause_sound)


func _end_pause():
	SoundManager.play_ui_sound(unpause_sound)


func _on_collect_coin():
	coin_players[coin_index].play(0.0)

	if coin_index < coin_players.size() - 1:
		coin_index += 1
	else:
		coin_index = 0
