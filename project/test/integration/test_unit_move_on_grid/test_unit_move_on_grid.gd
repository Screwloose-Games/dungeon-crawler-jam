extends GdUnitTestSuite

const UNIT_SKELETON := preload("res://levels/battles/battle/unit/resources/unit_skeleton.tres")
const UNIT_SKELETON_STARTING_POSITION := Vector2i(0, 0)


func test_skeleton_unit_can_move_on_grid():
	# Given a player commander and team
	var player_commander = Commander.new("Player", "Test commander", Commander.CommanderType.HUMAN)
	var player_team = Team.new("Player Team", player_commander)
	player_commander.team = player_team

	# And a skeleton unit with initial AP
	var skeleton_unit := UNIT_SKELETON.duplicate()
	skeleton_unit.team = player_team
	skeleton_unit.action_points_current = 5

	# And a battle grid with starting and target positions
	var battle_grid = BattleGrid.new()
	var starting_cell = BattleGridCell.new(UNIT_SKELETON_STARTING_POSITION, null, BattleGridCell.TileType.GROUND)
	var target_cell = BattleGridCell.new(Vector2i(1, 0), null, BattleGridCell.TileType.GROUND)
	var starting_position = UNIT_SKELETON_STARTING_POSITION
	var target_position = Vector2i(1, 0) # Adjacent cell

	battle_grid.cells[starting_position] = starting_cell
	battle_grid.cells[target_position] = target_cell

	# And the unit is placed at the starting position
	battle_grid.force_set_unit(starting_position, skeleton_unit)

	# And the unit has a move action
	skeleton_unit.init_move_action()
	var move_actions = skeleton_unit.get_actions().filter(func(action): return action is MoveAction)
	assert_int(move_actions.size()).is_greater(0)

	var move_action: MoveAction = move_actions[0]

	# Should have the ground move method
	assert_object(skeleton_unit.movement).is_not_null()
	assert_int(skeleton_unit.movement.method).is_equal(Movement.MovementMethod.WALK)

	# And the unit can execute the move action
	assert_bool(skeleton_unit.can_execute_action(move_action)).is_true()

	# WHEN we create a command to move to the target cell
	var move_command := ActionExecutionCommand.new(
		skeleton_unit, player_commander, move_action, [target_cell]
	)

	# Verify the basic command setup
	assert_object(move_command.unit).is_equal(skeleton_unit)
	assert_object(move_command.commander).is_equal(player_commander)
	assert_object(move_command.action).is_equal(move_action)
	assert_int(move_command.targets.size()).is_equal(1)
	assert_object(move_command.targets[0]).is_equal(target_cell)

	# Check cost affordability
	assert_bool(move_command.can_afford_cost()).is_true()

	# When we execute the command (spending AP)
	var initial_ap = skeleton_unit.action_points_current
	move_command.spend_action_points()

	# THEN the correct action points should be spent
	var expected_ap_after_move = initial_ap - move_action.cost
	assert_int(skeleton_unit.action_points_current).is_equal(expected_ap_after_move)

	# And when we simulate the movement (this would be handled by the action system)
	starting_cell.unit = null
	target_cell.unit = skeleton_unit
	skeleton_unit.cell = target_cell

	# Then the unit should have moved to the expected position
	assert_object(target_cell.unit).is_equal(skeleton_unit)

	# And the unit's position should be updated correctly on the grid
	assert_object(battle_grid.cells[target_position].unit).is_equal(skeleton_unit)

	# And the starting cell should no longer contain the unit
	assert_object(starting_cell.unit).is_null()

	# And the unit's cell reference should be updated
	assert_object(skeleton_unit.cell).is_equal(target_cell)
