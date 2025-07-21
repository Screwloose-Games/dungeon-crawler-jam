class_name NavigableConstraint
extends TargetTileConstraint

func is_valid(command: ActionExecutionCommand) -> bool:
	var path_start = command.unit.cell
	var path_end = command.targets[0]
	var move_method = command.unit.movement.method
	var path = command.battle_grid.get_movement_path(path_start, path_end, move_method)

	if not path:
		return false

	var max_path_length = command.unit.max_tile_move_count()

	return path.move_count <= max_path_length
