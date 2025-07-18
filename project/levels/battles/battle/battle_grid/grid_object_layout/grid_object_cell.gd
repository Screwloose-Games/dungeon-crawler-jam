class_name ObjectLayoutCell
extends Resource

@export var unit: Unit
@export var effect: Array[BattleGridCell.EffectType]
@export var team_index: int


func _init():
	effect = []
