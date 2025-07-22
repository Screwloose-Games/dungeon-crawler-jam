## Represents a tactical combat encounter on a [Battlefield] between multiple [Commander] units. [br]
## Coordinates turn-based gameplay where [Commander] units take actions through [UnitAction] commands. [br]
## Handles battle initialization, progression, and end conditions.
class_name Battle
extends Resource

## The grid-based battlefield where units are positioned and take actions
var battle_grid: BattleGrid

## The teams that are taking part in this battle
var teams: Array[Team]

## The conditions that determine when the battle can end
var end_conditions: Array[BattleEndCondition]

var battle_round: BattleRound


func create_from_scenario(scenario: BattleScenario) -> void:
	teams = scenario.teams
	end_conditions = scenario.end_conditions
	_create_battle_grid(scenario)
	_set_team_relationships(scenario.team_relationships)
	for team in teams:
		team.initialize(battle_grid)

	battle_round = BattleRound.new(teams)


func _create_battle_grid(scenario: BattleScenario):
	var chosen_layout: GridObjectLayout = null
	if scenario.grid_object_layouts and len(scenario.grid_object_layouts) > 0:
		chosen_layout = scenario.grid_object_layouts.pick_random()

	var battlefield = scenario.battlefield
	battle_grid = BattleGrid.new(battlefield, chosen_layout, teams)


func check_end_condition():
	for end_condition in end_conditions:
		var result: BattleResult = end_condition.check_condition(self)
		if result:
			GlobalSignalBus.battle_ended.emit(result)
	return null


func _set_team_relationships(team_relationships: Array[TeamRelationshipRecord]):
	for relation in team_relationships:
		Team.set_team_relationship(relation.team_a, relation.team_b, relation.relationship)


func begin():
	GlobalSignalBus.battle_started.emit(self)
