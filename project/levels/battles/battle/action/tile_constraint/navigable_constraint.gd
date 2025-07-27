## [TargetTileConstraint] that validates whether or not the unit can navigate to the specified targets
class_name NavigableConstraint
extends TargetTileConstraint

@export var check_movement_points: bool = true

func _validate_cell(
	command: ActionExecutionCommand,
	cell: BattleGridCell
) -> bool:
	var path_start = command.unit.cell
	var path_end = cell
	var move_method = command.unit.movement.method
	var path = command.battle_grid.get_movement_path(path_start, path_end, move_method)

	if not path:
		return false
	return true
