## Controls [Unit] units on a [Battlefield] during a [Battle]. [br]
## Alternates turns with any other [Commander] participating in the battle. [br]
## Controls when to end their turn and manages tactical decisions. [br]
## Can be either an AI or Human player controlling all [Unit] under their command. [br]
## Issues commands to [Unit] units through [UnitAction] actions via [ActionExecutionCommand].
class_name Commander
extends Resource

signal ended_turn

## Determines whether this commander is controlled by a human player or AI.
enum CommanderType {
	HUMAN,
	AI,
}

## Display name for this commander
@export var name: String
## Detailed description of the commander's background or characteristics
@export_multiline var description: String
## Whether this commander is controlled by human or AI
@export var type: CommanderType

@export var team: Team

var action_execution_command: ActionExecutionCommand
var previous_action_preview: ActionPreviewData
var battle_grid: BattleGrid

# Input related data
var selected_unit: Unit:
	set(new_unit):
		if new_unit == selected_unit:
			return
		if selected_unit:
			GlobalSignalBus.commander_unselected_unit.emit(selected_unit)
		selected_unit = new_unit
		if new_unit:
			GlobalSignalBus.commander_selected_unit.emit(selected_unit)

var selected_action: UnitAction
var hovered_cell: BattleGridCell
var targetted_cells: Array[BattleGridCell]
var input_locked: bool

var is_human: bool:
	get:
		return type == CommanderType.HUMAN


static func get_first_human_commander(commanders: Array[Commander]) -> Commander:
	var human_commander_index: int = commanders.find_custom(
		func(commander: Commander): return commander.is_human
	)
	if human_commander_index == -1:
		push_error("You must have at least 1 human commander")
		return null
	return commanders[human_commander_index]


func _init(
	name: String = "",
	description: String = "",
	type: CommanderType = CommanderType.HUMAN,
	team: Team = null
):
	self.name = name
	self.description = description
	self.type = type
	self.team = team


func can_command_unit(unit: Unit) -> bool:
	return is_on_same_team(unit)


func is_on_same_team(unit: Unit) -> bool:
	return team and unit and team == unit.team


func select_cell(cell: BattleGridCell) -> void:
	if input_locked:
		return
	if not cell:
		_select_unit(null)
	else:
		_select_unit(cell.unit)


func target_cell(cell: BattleGridCell):
	if not cell or input_locked:
		return
	if targetted_cells.find(cell) < 0:
		targetted_cells.append(cell)
	else:
		targetted_cells.erase(cell)

	_clear_action_preview()
	_update_action_execution_command()
	input_locked = true
	action_execution_command.execute(_on_command_completed)


func hover_cell(cell: BattleGridCell):
	if hovered_cell == cell or input_locked:
		return

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

	print("Commander %s selected unit %s" % [name, unit.name])

	selected_action = null
	if unit.team == self.team:
		selected_action = unit.get_move_action()

	_clear_action_preview()
	_update_action_execution_command()


func _clear_action_preview():
	if previous_action_preview:
		GlobalSignalBus.action_preview_cancelled.emit(previous_action_preview)
		previous_action_preview = null


func _update_action_execution_command(temp_target: BattleGridCell = null):
	action_execution_command = ActionExecutionCommand.new(
		selected_unit,
		self,
		battle_grid,
		selected_action,
		targetted_cells,
	)

	var prev_targets = action_execution_command.targets

	if temp_target:
		action_execution_command.targets = []
		action_execution_command.targets.append_array(prev_targets)
		action_execution_command.targets.append(temp_target)

	if not action_execution_command.is_valid():
		return

	var preview = action_execution_command.preview()
	if not preview:
		return
	previous_action_preview = preview
	GlobalSignalBus.action_preview_requested.emit(preview)
	action_execution_command.targets = prev_targets


func _on_command_completed():
	targetted_cells.clear()
	_clear_action_preview()
	input_locked = false


func end_turn():
	ended_turn.emit()
	GlobalSignalBus.team_ended_turn.emit(team)
