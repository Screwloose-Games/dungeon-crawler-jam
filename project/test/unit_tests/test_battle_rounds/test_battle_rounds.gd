class_name BattleRoundsTest
extends GdUnitTestSuite

const UNIT_SKELETON := preload("res://levels/battles/battle/unit/resources/unit_skeleton_knight.tres")
const UNIT_ROGUE := preload("res://levels/battles/battle/unit/resources/unit_rogue.tres")


func test_battle_can_be_started_and_rounds_executed() -> void:
	# Given a Human commander with a team and a rogue unit
	var human_commander = Commander.new("Player", "A human player", Commander.CommanderType.HUMAN)
	var player_team = Team.new("Player Team", human_commander)
	var rogue_unit := UNIT_ROGUE.duplicate()
	rogue_unit.team = player_team
	rogue_unit.action_points_current = 5

	# And an AI commander with a team and a skeleton unit
	var ai_commander = CommanderAI.new("AI", "An AI opponent", Commander.CommanderType.AI)
	var enemy_team = Team.new("Enemy Team", ai_commander)
	var skeleton_unit := UNIT_SKELETON.duplicate()
	skeleton_unit.team = enemy_team
	skeleton_unit.action_points_current = 3

	# And the teams are enemies
	Team.set_team_relationship(player_team, enemy_team, Team.Relationship.ENEMY_TEAM)

	# And a battle scenario with teams, relationships, and end conditions
	var battle_scenario = BattleScenario.new()
	battle_scenario.teams = [player_team, enemy_team] as Array[Team]

	var team_relationship = TeamRelationshipRecord.new()
	team_relationship.team_a = player_team
	team_relationship.team_b = enemy_team
	team_relationship.relationship = Team.Relationship.ENEMY_TEAM
	battle_scenario.team_relationships = [team_relationship] as Array[TeamRelationshipRecord]

	var end_condition = LastStandingEndCondition.new()
	battle_scenario.end_conditions = [end_condition] as Array[BattleEndCondition]

	# And a battlefield and grid object layout (minimal setup)
	var battlefield = Battlefield.new()
	var tile_data: Dictionary[Vector2i, BattleGridCell.TileType] = {
		Vector2i(0, 0): BattleGridCell.TileType.GROUND,
		Vector2i(1, 0): BattleGridCell.TileType.GROUND,
		Vector2i(0, 1): BattleGridCell.TileType.GROUND,
		Vector2i(1, 1): BattleGridCell.TileType.GROUND
	}
	battlefield.tile_data = tile_data
	battle_scenario.battlefield = battlefield
	battle_scenario.grid_object_layouts = [] as Array[GridObjectLayout]

	# When we create a battle from the scenario
	var battle = Battle.new()
	battle.create_from_scenario(battle_scenario)

	# Then the battle should be properly initialized
	assert_object(battle.teams).is_equal([player_team, enemy_team])
	assert_object(battle.end_conditions).is_equal([end_condition])
	assert_object(battle.battle_round).is_not_null()
	assert_object(battle.battle_grid).is_not_null()

	# And the battle round should have the correct turn order (human first)
	var battle_round = battle.battle_round
	assert_object(battle_round.turn_order).is_equal([player_team, enemy_team] as Array[Team])
	assert_int(battle_round.round_index).is_equal(0)
	assert_int(battle_round.turn_index).is_equal(0)

	# When the battle begins
	battle.begin()

	# Then the first round should start and the human commander should go first
	assert_int(battle_round.round_index).is_equal(0)
	assert_int(battle_round.turn_index).is_equal(1) # incremented after setting current turn
	assert_object(battle_round.current_turn_team).is_equal(player_team)

	# When the human commander ends their turn
	human_commander.end_turn()


	# Then the turn should end and move to the AI commander's turn
	#assert_int(battle_round.turn_index).is_equal(2) # incremented after AI turn starts
	#assert_object(battle_round.current_turn_team).is_equal(enemy_team)
	#assert_int(battle_round.round_index).is_equal(0) # still same round

	# When the AI commander ends their turn
	#ai_commander.end_turn()

	# Then the AI commander has ended their turn immediately
	await await_idle_frame()
	# Then the first round should end and the second round should begin
	assert_int(battle_round.round_index).is_equal(1) # moved to round 2
	assert_int(battle_round.turn_index).is_equal(1) # reset and incremented for new round
	assert_object(battle_round.current_turn_team).is_equal(player_team) # player goes first again

	# When the player ends their turn again
	human_commander.end_turn()
	await_idle_frame()

	# Then we are in round 2
	assert_int(battle_round.round_index).is_equal(1)
	assert_object(battle_round.current_turn_team).is_equal(enemy_team)
