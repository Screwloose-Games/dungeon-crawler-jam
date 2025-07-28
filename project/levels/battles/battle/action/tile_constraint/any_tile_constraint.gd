## A [TargetTileConstraint] that provides OR behavior for multiple constraints. [br]
## If any of the listed tile constraints are satisfied, this constraint is valid. [br]
## Use this when you want flexible targeting where multiple different conditions could work. [br]
## Contrasts with the default AND behavior when multiple constraints are used on an [Ability].
class_name AnyTargetTileConstraint
extends TargetTileConstraint

## Array of constraints where any one being satisfied makes this constraint valid
@export var constraints: Array[TargetTileConstraint]


func validate(command: ActionExecutionCommand) -> bool:
	for constraint in constraints:
		if constraint.validate(command):
			return true
	return false
