## Controls [Unit] units on a [Battlefield] during a [Battle]. [br]
## Alternates turns with any other [Commander] participating in the battle. [br]
## Controls when to end their turn and manages tactical decisions. [br]
## Can be either an AI or Human player controlling all [Unit] under their command. [br]
## Issues commands to [Unit] units through [UnitAction] actions via [ActionExecutionOrder].
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
