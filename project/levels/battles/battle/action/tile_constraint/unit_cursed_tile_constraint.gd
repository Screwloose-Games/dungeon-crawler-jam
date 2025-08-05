## [TargetTileConstraint] that checks that the target units are cursed
class_name UnitCursedTileConstraint
extends TargetTileConstraint

@export var invert: bool

func _validate_cell(_command: ActionExecutionCommand, cell: BattleGridCell) -> bool:
	if not cell.unit:
		return false
	var result = cell.unit.is_cursed
	if invert:
		result = not result

	return result


func derive_cells(command: ActionExecutionCommand) -> Variant:
	@warning_ignore("standalone_expression")
	var cursed_units = command.battle_grid.get_units().filter(func(unit): unit.is_cursed)
	var cells: Array[BattleGridCell]

	for unit in cursed_units:
		cells.append(unit.cell)

	return cells


func get_derivation_heuristic() -> float:
	# Until battle_grid implements get_units() in a way that does not check every cell, this derivation is very expensive
	return 1.0