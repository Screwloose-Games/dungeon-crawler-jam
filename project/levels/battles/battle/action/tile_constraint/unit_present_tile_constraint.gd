## A [TargetTileConstraint] that requires a [Unit] to be present on the target tile. [br]
## Essential for abilities that must target occupied cells, such as healing or attack spells. [br]
## When multiple [TargetTileConstraint] objects are used, all must be satisfied (AND behavior). [br]
## Use [AnyTargetTileConstraint] if you need OR behavior with other constraints.
class_name UnitPresentTargetTileConstraint
extends TargetTileConstraint

## Inverts the effect of the validation
@export var invert: bool = false


## Validates that a unit is present on the target tile. [br]
## [br]
## [b]Returns:[/b] True if a unit is present on the target tile, false otherwise.
func is_valid(command: ActionExecutionCommand):
	var valid: bool = _unit_is_present_on_all_targets(command.targets)
	if invert:
		return not valid
	return valid


func _unit_is_present_on_all_targets(targets: Array[BattleGridCell]):
	for target_cell in targets:
		if not target_cell.unit:
			return false
	return true
