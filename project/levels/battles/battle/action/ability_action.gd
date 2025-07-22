## A [UnitAction] that executes an [Ability]. [br]
class_name AbilityAction
extends UnitAction

## The specific ability that this action will execute when performed
@export var ability: Ability

var constraints: Array[TargetTileConstraint]:
	get = get_constraints


## Note: Will be Overridden later by any @export values set.
func _init(
	_name: String = "Ability Action",
	_description: String = "Execute a specific ability.",
	_base_cost: int = 1,
	_ability: Ability = null
):
	super (_name, _description, _base_cost)
	self.ability = _ability


## Calculates the action point cost for executing this ability. [br]
## Can be overridden to implement ability-specific cost modifications. [br]
## [br]
## [b]Returns:[/b] The calculated cost as an integer.
func get_cost():
	return base_cost


func get_constraints() -> Array[TargetTileConstraint]:
	if ability:
		return ability.constraints
	return []


func execute(command: ActionExecutionCommand, callback: Callable):
	ability.execute(command, callback)