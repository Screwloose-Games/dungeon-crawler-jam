extends TargetTileConstraint

func _validate_cell(command: ActionExecutionCommand, cell: BattleGridCell) -> bool:
	var from = command.unit.cell.position
	var to = cell.position

	var dx = abs(from.x - to.x)
	var dy = abs(from.y - to.y)

	return abs(dx) == abs(dy)
