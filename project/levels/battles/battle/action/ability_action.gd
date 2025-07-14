## A [UnitAction] that executes an [Ability]. [br]
class_name AbilityAction
extends UnitAction

## The specific ability that this action will execute when performed
@export var ability: Ability


## Calculates the action point cost for executing this ability. [br]
## Can be overridden to implement ability-specific cost modifications. [br]
## [br]
## [b]Returns:[/b] The calculated cost as an integer.
func get_cost():
	return base_cost
