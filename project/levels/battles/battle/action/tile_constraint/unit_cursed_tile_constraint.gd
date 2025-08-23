## [TargetTileConstraint] that checks that the target units are cursed
class_name UnitHasStatusEffectTypeConstraint
extends TargetTileConstraint

@export var invert: bool
@export var status_effect: StatusEffect

var status_effect_type: int:
	get:
		return typeof(status_effect)


func _validate_cell(_command: ActionExecutionCommand, cell: BattleGridCell) -> bool:
	if not cell.unit:
		return false
	var result = cell.unit.has_status_effect_type(status_effect_type)

	if invert:
		result = not result
	return result


func derive_cells(command: ActionExecutionCommand) -> Variant:
	var units_with_status_effect = command.battle_grid.get_units().filter(
		func(unit): return unit.has_status_effect_type(status_effect_type)
	)
	var cells: Array[BattleGridCell]

	for unit in units_with_status_effect:
		cells.append(unit.cell)

	return cells


func get_derivation_heuristic() -> float:
	# Until battle_grid implements get_units() in a way that does not check every cell,
	# this derivation is very expensive
	return 1.0