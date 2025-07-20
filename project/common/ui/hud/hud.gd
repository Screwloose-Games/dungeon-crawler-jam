extends Control

var current_team_turn: Team:
	set(val):
		if val == current_team_turn:
			return
		if Player.commander.team == val:
			show_current_player_turn_ui()
		else:
			show_enemy_player_turn_ui()
		current_team_turn = val

@onready var player_info_panel: PanelContainer = %PlayerInfoPanel
@onready var enemy_panel_root: Control = %EnemyPanelRoot


func _ready() -> void:
	GlobalSignalBus.battle_turn_started.connect(_on_turn_started)


func _on_turn_started(team: Team):
	current_team_turn = team
	print(team.name, " turn started in UI")


func wait_briefly():
	await get_tree().create_timer(0.2).timeout


func show_current_player_turn_ui():
	await wait_briefly()
	player_info_panel.visible = true
	enemy_panel_root.visible = false


func show_enemy_player_turn_ui():
	await wait_briefly()
	player_info_panel.visible = false
	enemy_panel_root.visible = true
