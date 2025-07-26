## A [UnitAction] that executes an [Ability]. [br]
class_name AbilityAction
extends UnitAction

## The specific ability that this action will execute when performed
@export var ability: Ability

## Note: Will be Overridden later by any @export values set.
func _init(
	_ability: Ability,
	_name: String = "Ability Action",
	_description: String = "Execute a specific ability.",
	_tile_constraints: Array[TargetTileConstraint] = []
):
	self.ability = _ability
	super (_name, _description, 0, ability.constraints)


## Calculates the action point cost for executing this ability. [br]
## Can be overridden to implement ability-specific cost modifications. [br]
## [br]
## [b]Returns:[/b] The calculated cost as an integer.
func get_minimum_ap_cost():
	return ability.get_minimum_ap_cost()


func preview(command: ActionExecutionCommand) -> ActionPreviewData:
	var result = ActionPreviewData.new()

	preview_target_constraints(command, result)
	if not result.valid:
		return result

	result.valid = true
	return result


func execute(command: ActionExecutionCommand, callback: Callable):
	ability.execute(command, callback)
