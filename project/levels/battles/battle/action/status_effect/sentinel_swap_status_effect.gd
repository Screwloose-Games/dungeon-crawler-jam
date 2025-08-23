class_name SentinelSwapStatusEffect
extends StatusEffect

@export var swap_action: UnitAction
@export var counterattack_action: UnitAction
var sentinel_unit: Unit

func apply(unit: Unit, command: ActionExecutionCommand = null):
	super.apply(unit, command)
	print("Tracking new signal")
	signal_tracker.add_signal(affected_unit.before_damage_applied, _on_before_unit_damage_applied)
	sentinel_unit = command.unit


func _on_before_unit_damage_applied(
	_damage_amount: int,
	attacking_unit: Unit,
	cancel_flag: CancelFlag,
	reactions: Array[Callable],
):
	print("before unit damage applied")
	cancel_flag.cancel = true

	print("adding reaction callback")
	var reaction_callback = _on_process_reaction.bind(affected_unit, attacking_unit, sentinel_unit)
	reactions.append(reaction_callback)


func _is_attacking_unit_ajacent(attacking_unit) -> bool:
	var diff: Vector2i = attacking_unit.cell.position - affected_unit.cell.position
	return abs(diff.x) + abs(diff.y) == 1


func _create_swap_command(
	sentinel_unit: Unit,
	attacked_unit: Unit
) -> ActionExecutionCommand:
	return ActionExecutionCommand.new(
		sentinel_unit,
		sentinel_unit.team.commander,
		sentinel_unit.cell.grid,
		swap_action,
		[attacked_unit.cell],
		true,
	)


func _create_counterattack_command(
	sentinel_unit: Unit,
	attacking_unit: Unit,
) -> ActionExecutionCommand:
	return ActionExecutionCommand.new(
		sentinel_unit,
		sentinel_unit.team.commander,
		sentinel_unit.cell.grid,
		counterattack_action,
		[attacking_unit.cell],
		true,
	)


func _on_process_reaction(
	wait_request: WaitRequest,
	affected_unit: Unit,
	attacking_unit: Unit,
	sentinel_unit: Unit,
) -> void:
	wait_request.register_blocker()

	var swap_command = _create_swap_command(sentinel_unit, affected_unit)
	await swap_command.execute_and_wait()

	if (
		not attacking_unit or
		not counterattack_action or
		not _is_attacking_unit_ajacent(attacking_unit)
	):
		return

	var counterattack_command = _create_counterattack_command(sentinel_unit, attacking_unit)
	await counterattack_command.execute_and_wait()

	wait_request.complete_blocker()
