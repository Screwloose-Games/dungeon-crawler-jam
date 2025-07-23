class_name BattlePlayerInput
extends Node2D

var selected_unit: Unit:
	set(new_unit):
		if new_unit == selected_unit:
			return
		if selected_unit:
			GlobalSignalBus.player_unselected_unit.emit(selected_unit)
		selected_unit = new_unit
		if new_unit:
			GlobalSignalBus.player_selected_unit.emit(selected_unit)


var battle: Battle
var selected_action: UnitAction
var hovered_cell: BattleGridCell
var targetted_cells: Array[BattleGridCell]
var input_locked: bool
var previous_action_preview: ActionPreviewData
var action_execution_command: ActionExecutionCommand
@onready var battle_grid_node: BattleGridNode = $"../BattleGridNode"


func initialize(battle: Battle):
	self.battle = battle


func _process(_delta: float):
	_handle_mouse_input()


func _handle_mouse_input():
	var mouse_position := get_global_mouse_position()
	var cell_coords = battle_grid_node.global_position_to_cell_coords(mouse_position)
	var cell = battle_grid_node.battle_grid.get_cell(cell_coords)

	if Input.is_action_just_pressed("left_click"):
		_select_cell(cell)
	elif Input.is_action_just_pressed("right_click"):
		_target_cell(cell)
	else:
		_hover_cell(cell)


func _select_cell(cell: BattleGridCell) -> void:
	if input_locked:
		return
	if not cell:
		_select_unit(null)
	else:
		_select_unit(cell.unit)


func _target_cell(cell: BattleGridCell):
	if not cell or input_locked:
		return
	if targetted_cells.find(cell) < 0:
		targetted_cells.append(cell)
	else:
		targetted_cells.erase(cell)

	_clear_action_preview()
	if _update_action_execution_command():
		input_locked = true
		print("Attempting command execution")
		action_execution_command.execute(_on_command_completed)
	targetted_cells = []


func _hover_cell(cell: BattleGridCell):
	if hovered_cell == cell or input_locked:
		return

	print("hover")
	hovered_cell = cell
	_clear_action_preview()

	if not selected_action or not selected_unit or not cell:
		return

	_update_action_execution_command(cell)


func _select_unit(unit: Unit):
	if selected_unit == unit or input_locked:
		return

	_clear_action_preview()
	selected_unit = unit

	if not unit:
		selected_action = null
		return

	selected_action = null
	if unit.team == Player.commander.team:
		selected_action = unit.get_move_action()

	_clear_action_preview()
	_update_action_execution_command()


func _clear_action_preview():
	if previous_action_preview:
		GlobalSignalBus.action_preview_cancelled.emit(previous_action_preview)
		previous_action_preview = null


func _update_action_execution_command(temp_target: BattleGridCell = null) -> bool:
	action_execution_command = ActionExecutionCommand.new(
		selected_unit,
		Player.commander,
		battle.battle_grid,
		selected_action,
		targetted_cells,
	)

	var prev_targets = action_execution_command.targets

	if temp_target:
		action_execution_command.targets = []
		action_execution_command.targets.append_array(prev_targets)
		action_execution_command.targets.append(temp_target)
	else:
		action_execution_command.targets = targetted_cells

	if len(action_execution_command.targets) == 0:
		return false

	var result = action_execution_command.validate()

	if not result.valid:
		for error in result.get_error_reasons():
			print(error)
		return false

	previous_action_preview = result
	GlobalSignalBus.action_preview_requested.emit(result)
	action_execution_command.targets = prev_targets
	return true


func _on_command_completed():
	targetted_cells.clear()
	_clear_action_preview()
	input_locked = false
