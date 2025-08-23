class_name SentinelSwapStatusEffect
extends StatusEffect

@export var counter_attack_damage: int
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
	var reaction_callback = _on_process_reaction.bind(attacking_unit, sentinel_unit)
	reactions.append(reaction_callback)


func _is_unit_adjacent_to_sentinel(unit) -> bool:
	var diff: Vector2i = unit.cell.position - sentinel_unit.cell.position
	return abs(diff.x) + abs(diff.y) == 1


func _create_swap_command(
	sentinel_unit: Unit,
	attacked_unit: Unit
) -> ActionExecutionCommand:
	var swap_ability_effect = UnitSwapEffect.new()
	var swap_ability_stage = AbilityStage.new("", "", [swap_ability_effect])
	var swap_ability = Ability.new("Swap", "", 1, [], [swap_ability_stage])
	var swap_action = AbilityAction.new(swap_ability)

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
	var counterattack_ability_effect = UnitApplyDamageEffect.new()
	counterattack_ability_effect.base_damage = counter_attack_damage
	var counterattack_ability_stage = AbilityStage.new("", "", [counterattack_ability_effect])
	var counterattack_ability = Ability.new("Counterattack", "", 1, [], [counterattack_ability_stage])
	var counterattack_action = AbilityAction.new(counterattack_ability)

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
	attacking_unit: Unit,
	sentinel_unit: Unit,
) -> void:
	wait_request.register_blocker()

	var swap_command = _create_swap_command(sentinel_unit, affected_unit)
	await swap_command.execute_and_wait()

	if (
		not attacking_unit or
		not _is_unit_adjacent_to_sentinel(attacking_unit)
	):
		return

	var counterattack_command = _create_counterattack_command(sentinel_unit, attacking_unit)
	await counterattack_command.execute_and_wait()

	wait_request.complete_blocker()
