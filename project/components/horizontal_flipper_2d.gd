## As a node in a CharacterBody2D scene, will translate itself flipped left and
## right according to the movement direction of the CharacterBody2D scene root.
extends Node2D
class_name HorizontalFlipper2D

## The `global_transform.x.x` when the CharacterBody2D is facing right.
const FACING_RIGHT_TRANSFORM: int = 1

var time_since_last_flip: float = 0
var min_time_since_last_flip: float = 0.3

@onready var translation_base: CharacterBody2D = owner


func _ready() -> void:
	if translation_base is not CharacterBody2D:
		push_error("Scene root must be a `CharacterBody2D`")


func can_flip():
	return time_since_last_flip >= min_time_since_last_flip


func flip():
	global_transform.x.x = -global_transform.x.x
	time_since_last_flip = 0


func _process(delta):
	time_since_last_flip += delta
	if is_moving_left() and not _is_facing_left() and can_flip():
		flip()
	elif is_moving_right() and _is_facing_left() and can_flip():
		flip()


func is_moving_left():
	return translation_base.velocity.x < 0


func is_moving_right():
	return translation_base.velocity.x > 0


func _is_facing_left():
	return global_transform.x.x == -FACING_RIGHT_TRANSFORM


func _face_left():
	global_transform.x.x = -FACING_RIGHT_TRANSFORM


func _face_right():
	global_transform.x.x = FACING_RIGHT_TRANSFORM
