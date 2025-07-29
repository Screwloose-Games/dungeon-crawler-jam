class_name RangeConstraint
extends TargetTileConstraint

enum RangeType
{
	DIAGONALS_COST_1,
	DIAGONALS_COST_2,
}

@export var min_range: int
@export var max_range: int
@export var type: RangeType

func _validate_cell(command: ActionExecutionCommand, cell: BattleGridCell) -> bool:
	var from = command.unit.cell.position
	var to = cell.position
	var distance: int = 0

	var dx = abs(to.x - from.x)
	var dy = abs(to.y - from.y)

	match type:
		# Chebyshev distance
		RangeType.DIAGONALS_COST_1:
			distance = max(dx, dy)
		# Manhattan distance
		RangeType.DIAGONALS_COST_2:
			distance = dy + dx
		_:
			assert(false, "RangeType not implemented")

	if max_range >= 0:
		return distance >= min_range and distance <= max_range
	return distance >= min_range
