extends Node2D

## Reference to the scenario to load the battle from
@export var battle_scenario: BattleScenario
@export var battle: Battle
@onready var battle_grid_node: BattleGridNode = $BattleGrid
@onready var effects: Node2D = $BattleGrid/Effects



func _ready() -> void:
	battle.create_from_scenario(battle_scenario)
	initialize()


func initialize():
	pass
