class_name Battle
extends Resource

@export var battle_grid: BattleGrid

func _ready():
	pass


func create_from_scenario(scenario: BattleScenario) -> void:
	# TODO get team information and end conditions
	var chosen_layout = scenario.grid_object_layouts.pick_random().duplicate()
	var battlefield = scenario.battlefield.duplicate()
	battle_grid.load(battlefield, chosen_layout)
