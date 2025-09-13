@tool
class_name BattleEditor
extends Node2D

@export var battle_scenario: BattleScenario:
	set(val):
		battle_scenario = val
		if battle_template:
			battle_template.battle_scenario = battle_scenario

@onready var battle_template: BattleNode = $BattleTemplate
