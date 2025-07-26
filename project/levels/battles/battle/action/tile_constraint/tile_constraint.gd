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
func validate(_command: ActionExecutionCommand, _preview: ActionPreviewData):
	pass
