class_name Team
extends Resource

enum Relationship
{
	SAME_TEAM,
	ALLY_TEAM,
	NEUTRAL_TEAM,
	ENEMY_TEAM,
}

@export var commander: Commander
@export var name: String
