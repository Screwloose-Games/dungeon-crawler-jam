class_name UnitTest
extends GdUnitTestSuite

const UNIT_SKELETON := preload("res://levels/battles/battle/unit/resources/unit_skeleton.tres")
const UNIT_SKELETON_STARTING_POSITION := Vector2i(0, 0)

const UNIT_ROGUE := preload("res://levels/battles/battle/unit/resources/unit_rogue.tres")
const UNIT_ROGUE_STARTING_POSITION := Vector2i(0, 1)

## Example: https://martinfowler.com/bliki/GivenWhenThen.html


# A Unit should load with all required fields
func test_skeleton_unit_has_required_fields():
	# Given a preloaded Skeleton unit
	var unit := UNIT_SKELETON

	# Then the unit should have a name
	assert_str(unit.name).is_not_empty()

	# And the unit should have a description
	assert_str(unit.description).is_not_empty()

	# And the unit should have at least one ability
	assert_int(unit.abilities.size()).is_greater(0)

	# And the unit should have a movement configuration
	assert_object(unit.movement).is_not_null()

	# And the unit should have valid sprite_frames
	assert_object(unit.sprite_frames).is_not_null()
	assert_bool(unit.sprite_frames.get_animation_names().size() > 0).is_true()

	# And the unit should have a portrait
	assert_object(unit.portrait).is_not_null()


func test_rogue_unit_spends_correct_ap_when_acting():
	# Given an enemy commander, team, and unit
	var enemy_commander = Commander.new("Player 2", "A mean one", Commander.CommanderType.AI)
	var enemy_team = Team.new("Enemy Team", enemy_commander)
	var target_unit := UNIT_SKELETON
	target_unit.team = enemy_team

	# And a player commander, team, and unit
	var player_commander = Commander.new("Jonny", "Really strong", Commander.CommanderType.HUMAN)
	var player_team = Team.new("Player Team", player_commander)
	var attacking_unit := UNIT_ROGUE
	attacking_unit.team = player_team

	# and the teams are enemies
	Team.set_team_relationship(player_team, enemy_team, Team.Relationship.ENEMY_TEAM)

	# And the target unit is in a battle grid with a cell at (0, 0)
	var battle_grid_cell: BattleGridCell = BattleGridCell.new()
	battle_grid_cell.unit = target_unit

	# And the unit has 5 action points
	attacking_unit.action_points_current = 5

	# And the ability costs 2 Action points
	var ability_consting_2_ap: Ability = Ability.new(
		"Melee Attack",
		"Basic melee attack ability.",
		1,  # targets
		[UnitTeamRelationConstraint.new(Team.Relationship.ENEMY_TEAM)],  # constraints
		[
			AbilityStage.new(
				"Damage Stage", "Deals damage to the target.", [UnitApplyDamageEffect.new(3)]
			)
		],
		2  # Base cost of 2 AP
	)

	# And the action uses the ability
	var action_costing_2_ap: UnitAction = AbilityAction.new(
		"Test Action", "Test action that costs 2 AP", 2, ability_consting_2_ap
	)

	# And the unit has the action
	attacking_unit.actions.append(action_costing_2_ap)
	var action_index: int = attacking_unit.get_actions().find(action_costing_2_ap)
	var action: UnitAction = attacking_unit.get_actions()[action_index]
	assert_bool(attacking_unit.can_execute_action(action)).is_true()

	# WHEN

	# We create a command to execute the action
	var command := ActionExecutionCommand.new(
		attacking_unit, player_commander, action, [battle_grid_cell]
	)

	# The command IS valid
	assert_bool(command.is_valid()).is_true()

	# When the action is executed
	command.execute()

	var expected_ap_after_action = attacking_unit.action_points_current - action.cost

	# Then the unit should have 3 AP left
	assert_int(attacking_unit.action_points_current).is_equal(3)
