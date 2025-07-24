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
func validate(command: ActionExecutionCommand, preview: ActionPreviewData):
	var valid: bool = _unit_is_present_on_all_targets(command.targets)
	if invert:
		valid = not valid

	if not valid:
		if invert:
			preview.add_error(tr("tile_occupied"))
		else:
			preview.add_error(tr("no_unit"))


func _unit_is_present_on_all_targets(targets: Array[BattleGridCell]) -> bool:
	for target_cell in targets:
		if not target_cell.unit:
			return false
	return true
