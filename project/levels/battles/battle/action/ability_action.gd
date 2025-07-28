## A [UnitAction] that executes an [Ability]. [br]
class_name AbilityAction
extends UnitAction

const DEFAULT_NAME = "Ability Action"
const DEFAULT_DESCRIPTION = "Execute a specific ability."

## The specific ability that this action will execute when performed
@export var ability: Ability

## Note: Will be Overridden later by any @export values set.
func _init(
	_ability: Ability,
	_name: String = DEFAULT_NAME,
	_description: String = DEFAULT_DESCRIPTION,
	_tile_constraints: Array[TargetTileConstraint] = []
):
	self.ability = _ability

	# Use ability name and description if none provided
	if _name == DEFAULT_NAME and _ability and _ability.name:
		_name = _ability.name

	if _description == DEFAULT_DESCRIPTION and _ability and _ability.description:
		_description = _ability.description

	super (_name, _description, 0, ability.constraints)


func preview(command: ActionExecutionCommand) -> ActionPreviewData:
	var preview = ability.preview(command)
	preview.action_point_cost = get_ap_cost(command)
	return preview


func execute(command: ActionExecutionCommand, callback: Callable):
	command.unit.spend_action_points(get_ap_cost(command))
	ability.execute(command, callback)


## Calculates the action point cost for executing this ability. [br]
## Can be overridden to implement ability-specific cost modifications. [br]
## [br]
## [b]Returns:[/b] The calculated cost as an integer.
func get_ap_cost(command: ActionExecutionCommand) -> int:
	return ability.get_ap_cost(command)


func get_minimum_ap_cost() -> int:
	return ability.get_minimum_ap_cost()
