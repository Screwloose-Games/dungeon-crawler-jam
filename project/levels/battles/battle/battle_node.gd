class_name BattleNode
extends Node2D

## Reference to the scenario to load the battle from
@export var battle_scenario: BattleScenario
var battle: Battle
var battle_grid_node: BattleGridNode


func _ready() -> void:
	initialize()


func initialize():
	battle = Battle.new()
	battle.create_from_scenario(battle_scenario)

	battle_grid_node = BattleGridNode.new(battle.battle_grid)
	battle_grid_node.name = "BattleGridNode"
	battle_grid_node.initialize()
	add_child(battle_grid_node)

	# For now, battle begins on scene start
	battle.begin()
