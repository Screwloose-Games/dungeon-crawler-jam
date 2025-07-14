extends Node2D

## Reference to the scenario to load the battle from
@export var battle_scenario: BattleScenario
var battle: Battle
var battle_grid: BattleGridNode

func _ready() -> void:
	initialize()


func initialize():
	battle = Battle.new()
	battle.create_from_scenario(battle_scenario)

	battle_grid = BattleGridNode.new()
	battle_grid.name = "BattleGrid"
	battle_grid.initialize(battle.battle_grid)
	add_child(battle_grid)
