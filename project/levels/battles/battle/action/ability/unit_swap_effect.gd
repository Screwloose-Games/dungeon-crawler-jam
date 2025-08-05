## An [AbilityEffect] that swaps the positions of units in the [Grid]. [br]
## Used for position manipulation abilities. [br]
## Can be used with [TargetTileConstraint] to ensure valid swap targets and destinations.
class_name UnitSwapEffect
extends AbilityEffect

## Swaps the positions of units between two tiles on the battlefield. [br]
## If only 1 target is defined, the caster will be swapperd with the target
## If two targets are defined, those two will be swapped
func apply(command: ActionExecutionCommand, return_signal: ReturnSignal):
	if not _ensure_targets_are_units(command):
		return

	if len(command.targets) == 1:
		_apply_swap(command.unit.unit, command.targets[0].unit, return_signal)
	elif len(command.targets) == 2:
		_apply_swap(command.targets[0].unit, command.targets[1].unit, return_signal)
	else:
		assert(
			false,
			"Unsupported number of targets for UnitSwapEffect: %d" % len(command.targets)
		)


func _apply_swap(unit_a: Unit, unit_b: Unit, return_signal: ReturnSignal):
	print("applying swap")
	var path_a = MovementPath.new([unit_a.cell, unit_b.cell], Movement.Method.TELEPORT)
	var path_b = MovementPath.new([unit_b.cell, unit_a.cell], Movement.Method.TELEPORT)

	unit_a.cell = null
	unit_b.cell = null

	return_signal.register_blocker()
	return_signal.register_blocker()

	var callback = func(): return_signal.complete_blocker()

	unit_a.move_along_path(path_a, callback)
	unit_b.move_along_path(path_b, callback)


func _ensure_targets_are_units(command: ActionExecutionCommand) -> bool:
	for target in command.targets:
		if not target.unit:
			return false
	return true
