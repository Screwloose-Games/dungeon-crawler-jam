class_name BattleNode
extends Node2D

## Reference to the scenario to load the battle from
@export var battle_scenario: BattleScenario
@export var next_scene: PackedScene
var battle: Battle

@onready var battle_grid_node: BattleGridNode = $BattleGridNode
@onready var battle_player_input: BattlePlayerInput = $BattlePlayerInput

func _ready() -> void:
	initialize()


func initialize():
	battle = Battle.new()
	battle.create_from_scenario(battle_scenario)
	battle_grid_node.initialize(battle.battle_grid)
	battle_player_input.initialize(battle)

	# For now, battle begins on scene start
	battle.begin()


func _on_battle_end_acknowledged():
	# Could not get this to work properly unless I hardcoded the file path here
	# Not even preloading the scene as a PackedScene worked
	# Need to revisit this to make next scene configurable for each battle
	get_tree().change_scene_to_file("res://levels/overworld/overworld.tscn")
