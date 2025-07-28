## [TargetTileConstraint] that validates whether the target is within a direct line of the unit
class_name DirectLineConstraint
extends TargetTileConstraint

func _validate_cell(command: ActionExecutionCommand, cell: BattleGridCell) -> bool:
	var from = command.unit.cell.position
	var to = cell.position

	var dx = abs(from.x - to.x)
	var dy = abs(from.y - to.y)

	return dx == 0 or dy == 0
