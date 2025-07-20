## Controls [Unit] units on a [Battlefield] during a [Battle]. [br]
## Alternates turns with any other [Commander] participating in the battle. [br]
## Controls when to end their turn and manages tactical decisions. [br]
## Can be either an AI or Human player controlling all [Unit] under their command. [br]
## Issues commands to [Unit] units through [UnitAction] actions via [ActionExecutionCommand].
class_name Commander
extends Resource

signal unit_selected(unit: Unit)

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

var selected_unit: Unit
var selected_action: UnitAction
var action_execution_command: ActionExecutionCommand
var battle_grid: BattleGrid

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


func select_unit(unit: Unit):
	if selected_unit == unit:
		return
	print("Commander %s selected unit %s" % [name, unit.name])

	selected_unit = unit
	unit_selected.emit(unit)
	selected_action = null
	if unit.team == self.team:
		selected_action = unit.get_move_action()


func hover_cell(cell: BattleGridCell):
	if selected_action and selected_unit:
		action_execution_command = ActionExecutionCommand.new(
			selected_unit,
			self,
			battle_grid,
			selected_action,
			[cell]
		)
		selected_action.preview(action_execution_command)
