@tool
extends ComponentArea2D
class_name HurtBoxComponent2D

signal hurt(hit_box, amount)

## the owner of the hurt box
@export var reciever: Node2D
## the amount of time before hurt can be applied again
@export var cooldown: float

var cooldown_left: float = 0.0


func is_hurt_on_cooldown() -> bool:
	if cooldown_left <= 0.0:
		return false
	return true


func apply_hurt(sender: Node2D, amount: float) -> void:
	if is_hurt_on_cooldown():
		return
	hurt.emit(sender, amount)
	prints(sender, "applied hurt for", amount)


func decrement_hurt_cooldown_left(delta) -> void:
	if cooldown_left > 0.0:
		cooldown_left -= delta


func reset_hurt_cooldown_left() -> void:
	cooldown_left = cooldown


func _physics_process(delta):
	decrement_hurt_cooldown_left(delta)
