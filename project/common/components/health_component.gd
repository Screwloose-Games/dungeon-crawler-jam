@tool
extends ComponentNode
class_name HealthComponent

@export var max_health: float = 100.0:
	set(f):
		max_health = f
		max_health_changed.emit(max_health)

@export var health: float = max_health:
	set(f):
		if f == health:
			return
		if healable == false and f > health:
			return
		if revivable == false and health == 0:
			return
		if invincible == true and f < health:
			return
		health = clampf(f, 0, max_health)
		health_changed.emit(health)
		if not is_alive and revivable and health > 0:
			is_alive = true

@export var invincible: bool = false:
	set(b):
		invincible = b
		invincible_changed.emit(invincible)

@export var healable: bool = true:
	set(b):
		healable = b
		healable_changed.emit(healable)

@export var revivable: bool = false:
	set(b):
		revivable = b
		revivable_changed.emit(revivable)

var is_alive := true

signal died
signal health_changed(health)
signal healed(amount)
signal damaged(amount)
signal max_health_changed(max_health)
signal invincible_changed(invincible)
signal healable_changed(healable)
signal revivable_changed(revivable)


func set_health_to_max():
	health = max_health


func die():
	is_alive = false
	print("Health componend die")
	died.emit()


func damage(amount: float):
	if not is_alive:
		return
	health -= amount
	damaged.emit(amount)
	if is_alive and health <= 0:
		die()


func heal(amount: float):
	health += amount
	healed.emit(amount)


func kill():
	damage(health)
