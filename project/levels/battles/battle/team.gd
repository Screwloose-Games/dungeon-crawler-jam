## Represents a group of allied [Unit] units controlled by a single [Commander]. [br]
## Teams define relationships between different groups. [br]
## Used to determine targeting rules, alliance behavior, and victory conditions in [Battle]. [br]
## Each team has a [Commander] who makes tactical decisions for all units in the group.
## NOTE: @experimental We may allow multiple commanders per team in the future.
class_name Team
extends Resource

enum Relationship {
	SAME_TEAM,
	ALLY_TEAM,
	NEUTRAL_TEAM,
	ENEMY_TEAM,
}

## The commander who controls and makes decisions for this team
@export var commander: Commander
## Display name for this team
@export var name: String
