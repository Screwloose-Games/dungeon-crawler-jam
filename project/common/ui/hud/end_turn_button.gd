extends TextureButton


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed():
	if not Player.commander:
		return
	GlobalSignalBus.team_ended_turn.emit(Player.commander.team)
