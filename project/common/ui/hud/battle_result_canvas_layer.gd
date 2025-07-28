extends CanvasLayer

@export var result: BattleResult:
	set(val):
		result = val
		if result == null:
			visible = false
			return

		visible = true
		if result.winning_team == Player.commander.team:
			label.text = "You won!"
		else:
			label.text = "You lost!"

@onready var ok_button: Button = %OkButton
@onready var label: Label = %Label


func _ready() -> void:
	hide()
	GlobalSignalBus.battle_ended.connect(_on_battle_ended)
	ok_button.pressed.connect(_on_ok_pressed)


func _on_battle_ended(battle_result: BattleResult):
	result = battle_result


func _on_ok_pressed():
	get_tree().reload_current_scene()
