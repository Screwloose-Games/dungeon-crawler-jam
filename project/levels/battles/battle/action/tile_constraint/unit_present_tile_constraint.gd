## A [TargetTileConstraint] that requires a [Unit] to be present on the target tile. [br]
## Essential for abilities that must target occupied cells, such as healing or attack spells. [br]
## When multiple [TargetTileConstraint] objects are used, all must be satisfied (AND behavior). [br]
## Use [AnyTargetTileConstraint] if you need OR behavior with other constraints.
class_name UnitPresentTargetTileConstraint
extends TargetTileConstraint


## Validates that a unit is present on the target tile. [br]
## [br]
## [b]Returns:[/b] True if a unit is present on the target tile, false otherwise.
func is_valid(_command: ActionExecutionCommand):
	pass
