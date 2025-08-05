## An [AbilityEffect] that will push a unit along a designated list of offsets
class_name PushAbilityEffect
extends AbilityEffect

## The offsets along which the unit will be pushed. Should be provided in increments.
## A push 2 units to the right would be represented as (1, 0), (1, 0)
@export var push_offsets: Array[Vector2i]

## Whether or not the offsets should automatically be reoriented dependening on casting direction
## If on, [member push_offsets] should indicate how the unit is expected to move from the perspective of the caster
## x-axis indicates left-right movement
## y-axis indicates push-pull movement. Negative is pull, positive is push
## If casting in a diagonal direction, the offsets will be re-oriented diagonally as well
@export var reorient: bool

func preview(_command: ActionExecutionCommand, _preview: ActionPreviewData):
	pass


func apply(command: ActionExecutionCommand, return_signal: ReturnSignal):
	for target in command.targets:
		if target.unit:
			_apply_to_target(command, target.unit, return_signal)


func _apply_to_target(
	command: ActionExecutionCommand,
	target_unit: Unit,
	return_signal: ReturnSignal
):
	if not target_unit.cell:
		return

	var offsets = push_offsets
	if reorient:
		var target_offset = target_unit.cell.position - command.origin_position
		if target_offset == Vector2i.ZERO:
			# If pushing from same cell, reorienting based on origin position doesn't make sense. Do nothing
			return
		offsets = _reorient_offsets(target_offset)

	var path = get_path_from_offsets(command, target_unit, offsets)

	return_signal.register_blocker()
	target_unit.move_along_path(
		path,
		Movement.Type.PUSHED,
		func(): return_signal.complete_blocker()
	)
	return_signal.all_participants_registered()


func get_path_from_offsets(
	command: ActionExecutionCommand,
	unit: Unit,
	offsets: Array[Vector2i]
) -> MovementPath:
	var path_cells: Array[BattleGridCell] = []
	path_cells.append(unit.cell)
	var position: Vector2i = unit.cell.position
	for offset in offsets:
		assert(abs(offset.x) <= 1 and abs(offset.y) <= 1, "Offset is too large")

		position += offset
		var next_cell = command.battle_grid.get_cell(position)
		if not next_cell or next_cell.unit:
			# Unit was pushed into a non-existing or ocucpied cell. Exit early
			return MovementPath.new(path_cells)
		path_cells.append(next_cell)
	return MovementPath.new(path_cells)


func _reorient_offsets(target_offset: Vector2i) -> Array[Vector2i]:
	var casting_direction = BattleGrid.get_snapped_direction(Vector2(target_offset), true)
	print("casting_direction: ", casting_direction)

	var rotation_amount = atan2(casting_direction.y, casting_direction.x)
	# Correct rotation to be relative to y axis
	rotation_amount -= PI * 0.5
	print("rotation_amount: ", rotation_amount)
	var rotation_transform = Transform2D(rotation_amount, Vector2.ZERO)

	var new_offsets: Array[Vector2i] = []
	for offset in push_offsets:
		var rotated_offset = rotation_transform * Vector2(offset).normalized()
		new_offsets.append(Vector2i(rotated_offset.round()))
		print("new_offset: ", Vector2i(rotated_offset.round()))

	return new_offsets
