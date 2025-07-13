class_name Commander
extends Resource

enum CommanderType
{
	HUMAN,
	AI,
}

@export var name: String
@export var description: String
@export var type: CommanderType