## A [TargetTileConstraint] that provides OR behavior for multiple constraints. [br]
## If any of the listed tile constraints are satisfied, this constraint is valid. [br]
## Use this when you want flexible targeting where multiple different conditions could work. [br]
## Contrasts with the default AND behavior when multiple constraints are used on an [Ability].
class_name AnyTargetTileConstraint
extends TargetTileConstraint

## Array of constraints where any one being satisfied makes this constraint valid
@export var constraints: Array[TargetTileConstraint]


## Validates that at least one of the member constraints is satisfied. [br]
## [br]
## [b]Returns:[/b] True if any member constraint is satisfied, false if all fail.
func is_valid(command: ActionExecutionCommand) -> bool:
	for constraint in constraints:
		if constraint.is_valid(command):
			return true
	return false
