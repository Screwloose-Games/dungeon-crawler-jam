extends Control

signal unit_selected(unit: Unit)
signal unit_unselected(unit: Unit)

@export var slide_duration: float = 0.3

var current_team_turn: Team:
	set(val):
		if val == current_team_turn:
			return
		if Player.commander.team == val:
			show_current_player_turn_ui()
		else:
			show_enemy_player_turn_ui()
		current_team_turn = val

var shown: bool

@onready var enemy_panel_root: Control = %EnemyPanelRoot
@onready var player_info_panel: PanelContainer = %PlayerInfoPanel
@onready var status_panel: MarginContainer = $PlayerInfoPanel/InfoPanelMargin/VerticalPanes/StatusPanel


func _ready() -> void:
	GlobalSignalBus.battle_turn_started.connect(_on_turn_started)
	GlobalSignalBus.player_selected_unit.connect(_on_unit_selected)
	GlobalSignalBus.player_unselected_unit.connect(_on_unit_unselected)


func _on_unit_selected(unit: Unit):
	# show_current_player_turn_ui()
	unit_selected.emit(unit)
	show_panel()


func _on_unit_unselected(_unit: Unit):
	# show_current_player_turn_ui()
	unit_unselected.emit(null)
	hide_panel()


func _on_turn_started(team: Team):
	current_team_turn = team
	print(team.name, " turn started in UI")


func wait_briefly():
	await get_tree().create_timer(0.2).timeout


func show_current_player_turn_ui():
	await wait_briefly()
	enemy_panel_root.visible = false


func show_enemy_player_turn_ui():
	await wait_briefly()
	enemy_panel_root.visible = true


func show_panel():
	shown = true
	slide_to(0, func(): return shown)


func hide_panel():
	shown = false
	slide_to(-player_info_panel.get_rect().size.x, func(): return not shown)


func slide_to(target_x: float, keep_running_condition: Callable):
	print("slide_to ", target_x)
	var target_pos := Vector2(target_x, 0)

	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", target_pos, slide_duration)

	while tween.is_running() and keep_running_condition.call():
		print(position)
		await get_tree().process_frame

	tween.kill()
