## Represents a tactical combat encounter on a [Battlefield] between multiple [Commander] units. [br]
## Coordinates turn-based gameplay where [Commander] units take actions through [UnitAction] commands. [br]
## Handles battle initialization, progression, and end conditions.
class_name Battle
extends Resource

@export var battle_grid: BattleGrid
## The scenario definition that describes the battle setup, objectives, and participants
@export var battle_scenario: BattleScenario
## The grid-based battlefield where units are positioned and take actions


func _ready():
	pass

func create_from_scenario(scenario: BattleScenario) -> void:
	# TODO get team information and end conditions
	var chosen_layout = scenario.grid_object_layouts.pick_random()
	var battlefield = scenario.battlefield
	battle_grid.load(battlefield, chosen_layout)
