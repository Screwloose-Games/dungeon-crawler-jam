class_name UnitAction
extends Resource

@export var base_cost: int

var cost: int:
	get = get_cost


func get_cost():
	return base_cost
