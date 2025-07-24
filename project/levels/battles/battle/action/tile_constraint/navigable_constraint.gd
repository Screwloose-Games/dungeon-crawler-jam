class_name NavigableConstraint
extends TargetTileConstraint


func validate(
	command: ActionExecutionCommand,
	preview: ActionPreviewData
):
	var path_start = command.unit.cell
	var path_end = command.targets[0]
	var move_method = command.unit.movement.method
	var path = command.battle_grid.get_movement_path(path_start, path_end, move_method)

	if not path:
		preview.add_error(tr("cannot_reach"))
		return false
