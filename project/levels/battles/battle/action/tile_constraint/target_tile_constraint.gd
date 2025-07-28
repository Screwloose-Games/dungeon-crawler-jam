## Base class for rules that determine valid targeting for [Ability] actions. [br]
## Multiple constraints can be defined per ability and all must be satisfied for a tile to be targetable (AND behavior). [br]
## Use [AnyTargetTileConstraint] for OR behavior where any constraint can be satisfied. [br]
## Constraints validate conditions such as terrain types, unit presence, range, status effects, and other tactical conditions. [br]
## Essential for creating precise targeting rules that define tactical ability behavior.
class_name TargetTileConstraint
extends Resource

## Validates whether the target tiles in [param _command] is valid for an ability or action. [br]
## Override this method in derived classes to implement specific constraint logic. [br]
## [br]
## [param preview] should be updated with the details of the validation
func validate(command: ActionExecutionCommand) -> bool:
	for target in command.targets:
		if not _validate_cell(command, target):
			return false
	return true


## Validates whether a specific cell satisfies the [TargetTileConstraint]
## Ignores any targets set on the command
## This function must be overriden on child classes
func _validate_cell(_command: ActionExecutionCommand, _cell: BattleGridCell) -> bool:
	return true
