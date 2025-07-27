class_name RangeConstraint
extends TargetTileConstraint

@export var min_range: int
@export var max_range: int

func _validate_cell(command: ActionExecutionCommand, cell: BattleGridCell) -> bool:
	var from = command.unit.cell.position
	var to = cell.position

	# Manhattan distance
	var distance = abs(from.y - to.y) + abs(from.x - to.x)

	if max_range >= 0:
		return distance >= min_range and distance <= max_range
	return distance >= min_range
