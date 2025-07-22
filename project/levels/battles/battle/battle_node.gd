class_name BattleNode
extends Node2D

## Reference to the scenario to load the battle from
@export var battle_scenario: BattleScenario
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
