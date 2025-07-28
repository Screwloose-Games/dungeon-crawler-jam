## A [TargetTileConstraint] that requires a [Unit] to be present on the target tile. [br]
## Essential for abilities that must target occupied cells, such as healing or attack spells. [br]
## When multiple [TargetTileConstraint] objects are used, all must be satisfied (AND behavior). [br]
## Use [AnyTargetTileConstraint] if you need OR behavior with other constraints.
class_name UnitPresentTargetTileConstraint
extends TargetTileConstraint

## Inverts the effect of the validation
@export var invert: bool = false


func _init(invert: bool = false):
	self.invert = invert


## Validates that a unit is present on the target tile.
func _validate_cell(_command: ActionExecutionCommand, cell: BattleGridCell) -> bool:
	var valid = cell.unit != null

	if invert:
		valid = not valid

	return valid
