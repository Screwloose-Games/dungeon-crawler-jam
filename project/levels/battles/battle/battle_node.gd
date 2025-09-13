@tool
class_name BattleNode
extends Node2D

## Reference to the scenario to load the battle from
@export var battle_scenario: BattleScenario:
	set(val):
		battle_scenario = val
		if not battle_grid_node:
			await ready
		initialize()
@export var next_scene: PackedScene
var battle: Battle

@onready var battle_grid_node: BattleGridNode = $BattleGridNode
@onready var battle_player_input: BattlePlayerInput = $BattlePlayerInput


func _ready() -> void:
	battle_scenario.changed.connect(_on_scenario_changed)
	initialize()


func _on_scenario_changed():
	initialize()


func initialize():
	battle = Battle.new()
	battle.create_from_scenario(battle_scenario)
	battle.battle_grid.battlefield = battle_scenario.battlefield
	if not battle_grid_node:
		await ready
	if battle_grid_node:
		print("initialized battle grid node")
		battle_grid_node.initialize(battle.battle_grid)
	if battle_player_input:
		battle_player_input.initialize(battle)

	# For now, battle begins on scene start
	battle.begin()


func _on_battle_end_acknowledged():
	# Could not get this to work properly unless I hardcoded the file path here
	# Not even preloading the scene as a PackedScene worked
	# Need to revisit this to make next scene configurable for each battle
	get_tree().change_scene_to_file("res://levels/overworld/overworld.tscn")
