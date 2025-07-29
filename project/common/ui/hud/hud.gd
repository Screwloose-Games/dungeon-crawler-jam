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

var selected_unit: Unit:
	set(new_unit):
		if selected_unit == new_unit:
			return
		if selected_unit:
			unit_unselected.emit(selected_unit)
		selected_unit = new_unit
		if not new_unit:
			hide_panel()
		else:
			unit_selected.emit(selected_unit)
			update_actions(selected_unit)
			show_panel()


var selected_action: UnitAction:
	set(new_action):
		if selected_action == new_action:
			return
		if selected_action:
			GlobalSignalBus.player_unselected_action.emit(selected_action)
		selected_action = new_action
		if new_action:
			GlobalSignalBus.player_selected_action.emit(selected_action)


var shown: bool

@onready var enemy_panel_root: Control = %EnemyPanelRoot
@onready var player_info_panel: PanelContainer = %PlayerInfoPanel
@onready var status_panel: MarginContainer = $PlayerInfoPanel/InfoPanelMargin/VerticalPanes/StatusPanel
@onready var action_list: ItemList = $PlayerInfoPanel/InfoPanelMargin/VerticalPanes/ActionPane/ActionList
@onready var end_turn_button: TextureButton = %EndTurnButton


func _ready() -> void:
	GlobalSignalBus.battle_turn_started.connect(_on_turn_started)
	GlobalSignalBus.player_selected_unit.connect(_on_unit_selected)
	GlobalSignalBus.player_unselected_unit.connect(_on_unit_unselected)
	GlobalSignalBus.command_started.connect(_on_command_started)
	GlobalSignalBus.command_completed.connect(_on_command_completed)
	action_list.item_selected.connect(_on_action_list_item_selected)

	# Start with hidden panel
	hide_panel(0)


func _on_unit_selected(unit: Unit):
	selected_unit = unit


func _on_unit_unselected(_unit: Unit):
	selected_unit = null


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


func show_panel(duration: float = slide_duration):
	shown = true
	slide_to(
		0,
		func(): return shown,
		duration
	)


func hide_panel(duration: float = slide_duration):
	shown = false
	slide_to(
		- player_info_panel.get_rect().size.x,
		func(): return not shown,
		duration
	)


func slide_to(
	target_x: float,
	keep_running_condition: Callable,
	duration: float = slide_duration
):
	var target_pos := Vector2(target_x, 0)
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", target_pos, duration)

	while tween.is_running() and keep_running_condition.call():
		await get_tree().process_frame

	tween.kill()


func update_actions(unit: Unit):
	print("update actions")
	action_list.clear()
	if unit.team != Player.commander.team:
		return

	action_list.item_count = len(unit.actions)
	for i in len(unit.actions):
		var action = unit.actions[i]
		action_list.set_item_text(i, action.name)
		action_list.set_item_selectable(i, true)

	# Select first action by default
	selected_action = selected_unit.actions[0]
	action_list.select(0)


func _on_action_list_item_selected(index: int):
	selected_action = selected_unit.actions[index]


func _on_command_started(_command: ActionExecutionCommand):
	end_turn_button.disabled = true


func _on_command_completed(_command: ActionExecutionCommand):
	end_turn_button.disabled = false
