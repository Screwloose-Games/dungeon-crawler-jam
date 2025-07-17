class_name AbilityMoveEffectTest
extends GdUnitTestSuite


## Test instantiation of AbilityMoveEffect
func test_ability_move_effect_instantiation() -> void:
	var effect: AbilityMoveEffect = AbilityMoveEffect.new()
	assert_object(effect).is_not_null()
	assert_float(effect.movement_duration).is_equal(0.5)
	assert_bool(effect.instant_movement).is_false()


## Test get_duration method with normal movement
func test_get_duration_normal_movement() -> void:
	var effect: AbilityMoveEffect = AbilityMoveEffect.new(2.0, false)
	assert_float(effect.get_duration()).is_equal(2.0)


## Test get_duration method with instant movement
func test_get_duration_instant_movement() -> void:
	var effect: AbilityMoveEffect = AbilityMoveEffect.new(2.0, true)
	assert_float(effect.get_duration()).is_equal(0.0)


## Test apply method with valid movement
func test_apply_valid_movement() -> void:
	var effect: AbilityMoveEffect = AbilityMoveEffect.new()

	# Given there is a unit, starting, target, and command
	var unit: Unit = Unit.new()
	var start_cell: BattleGridCell = BattleGridCell.new()
	var target_cell: BattleGridCell = BattleGridCell.new()
	var command: ActionExecutionCommand = ActionExecutionCommand.new()

	# And we set up the scenario
	unit.cell = start_cell
	start_cell.unit = unit
	target_cell.unit = null
	command.unit = unit
	command.targets = [target_cell]

	# When we apply the effect based on the command
	effect.apply(command)

	# THEN the movement should have occurred
	assert_object(target_cell.unit).is_equal(unit)
	assert_object(unit.cell).is_equal(target_cell)
	assert_object(start_cell.unit).is_null()


## Test apply method with occupied target cell
func test_apply_occupied_target_cell() -> void:
	var effect: AbilityMoveEffect = AbilityMoveEffect.new()

	# When we have a unit, other unit, start and end cells and execution order...
	var unit: Unit = Unit.new()
	var other_unit: Unit = Unit.new()
	var start_cell: BattleGridCell = BattleGridCell.new()
	var target_cell: BattleGridCell = BattleGridCell.new()
	var command: ActionExecutionCommand = ActionExecutionCommand.new()

	# And we have a grid with occupied an target
	unit.cell = start_cell
	start_cell.unit = unit
	target_cell.unit = other_unit

	command.unit = unit
	command.targets = [target_cell]

	# When we apply the move effect
	effect.apply(command)

	# THEN the movement was blocked
	assert_object(start_cell.unit).is_equal(unit)
	assert_object(unit.cell).is_equal(start_cell)
	assert_object(target_cell.unit).is_equal(other_unit)
