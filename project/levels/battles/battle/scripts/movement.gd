##

class_name Movement
extends Resource

enum MovementMethod { WALK, FLY, JUMP }

@export var movement_points_per_ap: int = 2
var method: MovementMethod = MovementMethod.WALK

var can_move: bool:
	get:
		return _has_movement_points

## The purchased, remaining movement points.
var _movement_points: int = 0

var _has_movement_points: bool:
	get:
		return _movement_points > 0


func purchase_movement_points(_ap):
	pass
