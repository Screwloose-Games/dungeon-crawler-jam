## Represents a tactical combat encounter on a [Battlefield] between multiple [Commander] units. [br]
## Coordinates turn-based gameplay where [Commander] units take actions through [UnitAction] commands. [br]
## Handles battle initialization, progression, and end conditions.
class_name Battle
extends Resource

## The scenario definition that describes the battle setup, objectives, and participants
@export var battle_scenario: BattleScenario

## The grid-based battlefield where units are positioned and take actions
var battle_grid: BattleGrid

## The teams that are taking part in this battle
var teams: Array[Team]

# TODO: Use a better way to represent these relationships
# as is, its not very clear what each index in the array represents
# it's also very redundant
## The relationships between the teams taking part in this battle
var team_relationships: Array[Team.Relationship]

func create_from_scenario(scenario: BattleScenario) -> void:
	teams = scenario.teams
	team_relationships = scenario.team_relationships
	_create_battle_grid(scenario)


func _create_battle_grid(scenario: BattleScenario):
	var chosen_layout = scenario.grid_object_layouts.pick_random()
	var battlefield = scenario.battlefield
	battle_grid = BattleGrid.new()
	battle_grid.load(battlefield, chosen_layout)


func get_team_relationship(team_a: Team, team_b: Team) -> Team.Relationship:
	if team_a == team_b:
		return Team.Relationship.SAME_TEAM
	var a_index = teams.find(team_a)
	var b_index = teams.find(team_b)

	var relationship_index = a_index * len(teams) + b_index
	return team_relationships[relationship_index]
