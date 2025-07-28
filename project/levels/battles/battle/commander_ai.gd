## AI-controlled [Commander] that makes tactical decisions for melee units in battle. [br]
## Implements specific tactical behaviors for controlling a single melee unit with move and attack capabilities. [br]
## Uses helper functions to evaluate the battlefield and make optimal decisions based on proximity to enemies.
class_name CommanderAI
extends Commander


func _init(
	commander_name: String = "",
	commander_description: String = "",
	_type: CommanderType = CommanderType.AI,
	commander_team: Team = null
):
	super(commander_name, commander_description, CommanderType.AI, commander_team)
	GlobalSignalBus.battle_turn_started.connect(_on_battle_turn_started)


func _on_battle_turn_started(battle_team: Team):
	if battle_team != self.team:
		return
	start_turn.call_deferred()  # wait for units to get ready. :/


func start_turn():
	print("Starting AI turn")

	var units: Array[Unit] = get_units()

	for unit in units:
		print("Checking unit: ", unit)
		var took_action = take_actions_for_unit(unit)
		print("took action:", took_action)

	print("All units have finished acting")
	end_turn.call_deferred()
	print.call_deferred("done")


func get_units() -> Array[Unit]:
	if not team:
		return []
	return team.units


func get_first_unit_that_can_act(units: Array[Unit]) -> Unit:
	for unit in units:
		if unit.can_act():
			return unit
	return null


func move_to_melee_and_attack(unit: Unit, target_enemy: Unit, melee_attack_action: AbilityAction):
	if is_adjacent_to_enemy(unit, target_enemy):
		attack_enemy(unit, target_enemy, melee_attack_action)
	else:
		var valid_move_targets: Array[BattleGridCell] = unit.get_valid_adjacent_move_targets(
			target_enemy
		)
		var target_cell = unit.get_closest_cell_in_move_range(valid_move_targets)
		if target_cell:
			move_unit_to_cell(unit, target_cell)


func get_melee_attack_action(unit: Unit) -> AbilityAction:
	for action in unit.get_actions():
		if action is AbilityAction:
			var ability_action = action as AbilityAction
			if (
				ability_action.ability.name.to_lower().contains("melee")
				or ability_action.ability.name.to_lower().contains("attack")
			):
				return ability_action
	return null


func find_closest_enemy_unit(unit: Unit) -> Unit:
	return unit.get_closest_enemy()


func get_distance_between_units_direct(unit1: Unit, unit2: Unit) -> float:
	if not unit1.cell or not unit2.cell:
		return INF
	var pos1 = Vector2(unit1.cell.position)
	var pos2 = Vector2(unit2.cell.position)
	return pos1.distance_to(pos2)


func is_adjacent_to_enemy(unit: Unit, enemy: Unit) -> bool:
	if not unit.cell or not enemy.cell:
		return false
	var distance = get_distance_between_units_direct(unit, enemy)
	return distance <= 1.0


func move_unit_to_cell(unit: Unit, target_cell: BattleGridCell):
	var move_action = unit.get_move_action()
	if not move_action:
		print("Unit ", unit.name, " has no move action")
		return

	if not unit.can_afford_action(move_action):
		print("Unit ", unit.name, " cannot afford to move")
		return

	print("Moving unit ", unit.name, " to position ", target_cell.position)

	var command = ActionExecutionCommand.new(unit, self, battle_grid, move_action, [target_cell])

	if command.validate():
		command.execute(func(): print("Move completed for ", unit.name))
	else:
		print("Move command invalid for unit ", unit.name)


func attack_enemy(unit: Unit, target_enemy: Unit, melee_attack_action: AbilityAction):
	if not unit.can_afford_action(melee_attack_action):
		print("Unit ", unit.name, " cannot afford to attack")
		return

	print("Unit ", unit.name, " attacking ", target_enemy.name)

	var command = ActionExecutionCommand.new(
		unit, self, battle_grid, melee_attack_action, [target_enemy.cell]
	)

	if command.validate():
		command.execute(func(): print("Attack completed by ", unit.name))
	else:
		print("Attack command invalid for unit ", unit.name)


func take_actions_for_unit(unit: Unit):
	var melee_attack_action = get_melee_attack_action(unit)
	if not melee_attack_action:
		print("Unit ", unit.name, " has no melee attack action")
		return

	var closest_enemy = find_closest_enemy_unit(unit)
	if not closest_enemy:
		print("No enemy units found for unit ", unit.name)
		return
	if unit.can_move_adjacent_to(closest_enemy.cell):
		move_to_melee_and_attack(unit, closest_enemy, melee_attack_action)
	else:
		print("Unit ", unit.name, " cannot move adjacent to enemy ", closest_enemy.name)
		return

	#move_to_melee_and_attack(unit, closest_enemy, melee_attack_action)
