class_name DirectLineConstraint
extends TargetTileConstraint


func validate(command: ActionExecutionCommand, preview: ActionPreviewData):
	for target in command.targets:
		if not is_target_valid(command.unit, target):
			preview.add_error(tr("not_direct"))
			return


func is_target_valid(unit: Unit, target: BattleGridCell) -> bool:
	var from = unit.cell.position
	var to = target.position

	var dx = abs(from.x - to.x)
	var dy = abs(from.y - to.y)

	return dx == 0 or dy == 0
