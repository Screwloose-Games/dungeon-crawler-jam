class_name RangeConstraint
extends TargetTileConstraint

@export var min_range: int
@export var max_range: int


func validate(
	command: ActionExecutionCommand,
	preview: ActionPreviewData
):
	for target in command.targets:
		if not is_target_valid(command.unit, target):
			preview.add_error(tr("out_of_range"))
			return


func is_target_valid(unit: Unit, target: BattleGridCell) -> bool:
	var from = unit.cell.position
	var to = target.position

	# Manhattan distance
	var distance = abs(from.y - to.y) + abs(from.x - to.x)

	if max_range >= 0:
		return distance >= min_range and distance <= max_range
	return distance >= min_range
