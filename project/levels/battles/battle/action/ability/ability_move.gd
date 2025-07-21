class_name MoveAbility
extends Ability
## A special movement ability that allows units to move on the battlefield. [br]
## Extends the base Ability class with specific movement mechanics.
## @experimental
## May use ability for movement in the future.

## The method used for movement (e.g., "walk", "teleport", "dash")
@export var movement: Movement


## Initialize the move ability with the given parameters
func init(
	p_name: String = "Move",
	p_description: String = "Move to a target location",
	p_number_of_targets: int = 1,
	p_constraints: Array[TargetTileConstraint] = [],
	p_stages: Array[AbilityStage] = [],
	p_base_cost: int = 1,
	p_movement: Movement = null
) -> void:
	name = p_name
	description = p_description
	number_of_targets = p_number_of_targets
	constraints = p_constraints
	stages = p_stages
	base_cost = p_base_cost
	movement = p_movement