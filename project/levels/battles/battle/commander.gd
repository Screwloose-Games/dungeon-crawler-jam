## Controls [Unit] units on a [Battlefield] during a [Battle]. [br]
## Alternates turns with any other [Commander] participating in the battle. [br]
## Controls when to end their turn and manages tactical decisions. [br]
## Can be either an AI or Human player controlling all [Unit] under their command. [br]
## Issues commands to [Unit] units through [UnitAction] actions via [ActionExecutionCommand].
class_name Commander
extends Resource

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
