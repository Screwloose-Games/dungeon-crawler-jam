class_name BattlePlayerInput
extends Node2D

var selected_unit: Unit:
	set(new_unit):
		if new_unit == selected_unit:
			return
		if selected_unit:
			_on_unit_unselected(selected_unit)
		selected_unit = new_unit
		if new_unit:
			_on_unit_selected(selected_unit)
		_update_action_execution_command()

var selected_action: UnitAction:
	set(new_action):
		if new_action == selected_action:
			return
		selected_action = new_action
		_update_action_execution_command()


var hovered_cell: BattleGridCell:
	set(new_cell):
		if hovered_cell == new_cell:
			return
		hovered_cell = new_cell
		_update_action_execution_command()


var battle: Battle
var input_locked: bool
var running_command: ActionExecutionCommand
var hide_preview: bool

# Command data
var targetted_cells: Array[BattleGridCell]
var action_execution_command: ActionExecutionCommand

# Preview data
var previous_action_preview: ActionPreviewData

@onready var battle_grid_node: BattleGridNode = $"../BattleGridNode"


func initialize(battle: Battle):
	self.battle = battle
	GlobalSignalBus.player_selected_action.connect(_on_player_selected_action)
	GlobalSignalBus.player_unselected_action.connect(_on_player_unselected_action)
	GlobalSignalBus.command_started.connect(_on_command_started)
	GlobalSignalBus.command_completed.connect(_on_command_completed)
	GlobalSignalBus.battle_turn_started.connect(_on_battle_turn_started)
	battle.battle_grid.changed.connect(_on_battlegrid_changed)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		var mouse_event = event as InputEventMouse
		_handle_mouse_input(mouse_event)


func _handle_mouse_input(event: InputEventMouse):
	var mouse_position := get_global_mouse_position()
	var cell_coords = battle_grid_node.global_position_to_cell_coords(mouse_position)
	var cell = battle_grid_node.battle_grid.get_cell(cell_coords)

	if event.button_mask & MOUSE_BUTTON_MASK_LEFT > 0:
		_select_cell(cell)
	elif event.button_mask & MOUSE_BUTTON_RIGHT > 0:
		_target_cell(cell)
	else:
		_hover_cell(cell)


func _select_cell(cell: BattleGridCell) -> void:
	if input_locked:
		return
	if not cell:
		selected_unit = null
	else:
		selected_unit = cell.unit


func _target_cell(cell: BattleGridCell):
	if not cell or input_locked:
		return
	if targetted_cells.find(cell) < 0:
		targetted_cells.append(cell)

	if _update_action_execution_command(true):
		input_locked = true
		print("input locked")
		action_execution_command.execute(_on_action_completed)
		targetted_cells = []


func _hover_cell(cell: BattleGridCell):
	if hovered_cell == cell or input_locked:
		return

	hovered_cell = cell


func _select_unit(unit: Unit):
	if selected_unit == unit or input_locked:
		return

	selected_unit = unit
	selected_action = null

	if not unit:
		return

	if unit.team == Player.commander.team:
		selected_action = unit.get_move_action()

	_clear_action_preview()
	_update_action_execution_command()


func _clear_action_preview():
	if previous_action_preview:
		GlobalSignalBus.action_preview_cancelled.emit(previous_action_preview)
		previous_action_preview = null


func _update_action_execution_command(ignore_hover: bool = false) -> bool:
	if running_command:
		return false

	_clear_action_preview()

	if not selected_unit:
		return false

	if selected_unit.team != Player.commander.team:
		return false

	action_execution_command = ActionExecutionCommand.new(
		selected_unit,
		Player.commander,
		battle.battle_grid,
		selected_action,
		targetted_cells.duplicate(),
	)

	if not ignore_hover and hovered_cell:
		action_execution_command.targets.append(hovered_cell)

	if not action_execution_command.is_complete():
		return false

	if not ignore_hover or action_execution_command.target_count_satisfied():
		try_show_command_preview(action_execution_command)

	return action_execution_command.validate()


func try_show_command_preview(command: ActionExecutionCommand):
	if hide_preview:
		return

	var highlights = command.get_targetable_highlights()
	var preview = ActionPreviewData.new()

	var action_preview = command.preview()
	if action_preview and command.validate():
		preview = action_preview

	preview.highlighted_cells = highlights.merged(preview.highlighted_cells, true)

	GlobalSignalBus.action_preview_requested.emit(preview)
	previous_action_preview = preview


func _on_action_completed():
	targetted_cells.clear()
	_clear_action_preview()
	input_locked = false
	print("input unlocked")
	_update_action_execution_command()


func _on_player_selected_action(action: UnitAction):
	selected_action = action


func _on_player_unselected_action(_action: UnitAction):
	selected_action = null


func _on_unit_selected(unit: Unit):
	assert(unit, "Tried to select null unit")
	GlobalSignalBus.player_selected_unit.emit(selected_unit)
	if not unit.died.is_connected(_on_unit_died):
		unit.died.connect(_on_unit_died)


func _on_unit_unselected(unit: Unit):
	assert(selected_unit, "Tried to unselect unit, but no unit was selected")

	GlobalSignalBus.player_unselected_unit.emit(selected_unit)
	if unit.died.is_connected(_on_unit_died):
		unit.died.disconnect(_on_unit_died)


func _on_unit_died():
	selected_unit = null


func _on_command_started(command: ActionExecutionCommand):
	running_command = command


func _on_command_completed(_command: ActionExecutionCommand):
	running_command = null
	_update_action_execution_command()


func _on_battlegrid_changed():
	_update_action_execution_command()


func _on_battle_turn_started(team: Team):
	hide_preview = team != Player.commander.team
	_update_action_execution_command()
