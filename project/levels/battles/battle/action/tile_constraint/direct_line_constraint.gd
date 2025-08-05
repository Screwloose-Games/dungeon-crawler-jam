## [TargetTileConstraint] that validates whether the target is within a direct line of the unit
class_name DirectLineConstraint
extends TargetTileConstraint

const OFFSETS: Array[Vector2i] = [
	Vector2i(0, 1),
	Vector2i(1, 0),
	Vector2i(0, -1),
	Vector2i(-1, 0),
]

@export var target_through_units: bool

func _validate_cell(command: ActionExecutionCommand, cell: BattleGridCell) -> bool:
	var from = command.origin_position
	var to = cell.position

	var dx = abs(from.x - to.x)
	var dy = abs(from.y - to.y)

	return dx == 0 or dy == 0


func derive_cells(command: ActionExecutionCommand) -> Variant:
	var cells: Array[BattleGridCell] = []
	cells.append(command.unit.cell)

	var start_pos = command.origin_position

	for neighbor in OFFSETS:
		for i in range(1, MAX_RANGE + 1):
			var cell = command.battle_grid.get_cell(start_pos + neighbor * i)
			if cell:
				cells.append(cell)
				if cell.unit and not target_through_units:
					# We hit a unit, so exit early
					break

	return cells


func get_derivation_heuristic() -> float:
	return 0.10
