extends Node

@export var music: AudioStream
@onready var music_player: AudioStreamPlayer = $music_player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.game_paused.connect(_on_start_pause)
	GlobalSignalBus.game_unpaused.connect(_on_stop_pause)
	music_player.stream = music
	music_player.play(0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pause() -> void:
	pass


## Resume from previous song time
func _on_stop_pause() -> void:
	pass
