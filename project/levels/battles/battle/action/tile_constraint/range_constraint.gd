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
	var from = command.origin_position
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


func derive_cells(command: ActionExecutionCommand) -> Variant:
	var offset = Vector2i(1, 1)
	var direction = Vector2i(0, -1)
	var steps: int = 2

	var low: int = min_range
	var high: int = max_range
	if max_range < 0:
		high = MAX_RANGE

	if type == RangeType.DIAGONALS_COST_2:
		offset = Vector2i(0, 1)
		direction = Vector2i(1, -1)
		steps = 1
	var positions: Array[Vector2i] = []

	for i in range(low, high + 1):
		for s in range(0, i * steps):
			var point = offset * i + direction * s
			positions.append(point)
			positions.append(Vector2i(point.y, -point.x))
			positions.append(Vector2i(-point.x, -point.y))
			positions.append(Vector2i(-point.y, point.x))

	var cells: Array[BattleGridCell] = []
	for position in positions:
		var cell = command.battle_grid.get_cell(position + command.origin_position)
		if cell:
			cells.append(cell)

	return cells


func get_derivation_heuristic() -> float:
	# https://www.desmos.com/calculator/e7j9wezxys
	# Assuming approximate 30x30 battlegrid
	const HALF_GRID_SIDE_LENGTH: float = 15
	const QUARTER_GRID_AREA: float = HALF_GRID_SIDE_LENGTH * HALF_GRID_SIDE_LENGTH

	var low = float(min_range)
	var high = float(max_range)

	# Negative max range indicates no maximum
	if max_range < 0:
		high = MAX_RANGE

	var heuristic: float = (high * high - low * low) / QUARTER_GRID_AREA
	if type == RangeType.DIAGONALS_COST_2:
		heuristic /= 2.0

	return heuristic
