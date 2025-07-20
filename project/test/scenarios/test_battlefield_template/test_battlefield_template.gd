extends Node2D

@export var battle_scenario: BattleScenario
@onready var battle_template: BattleNode = %BattleTemplate


func _ready() -> void:
	battle_template.battle_scenario = battle_scenario
