class_name Health
extends Resource

signal died
signal health_changed(new_health: int)
signal damaged(amount: int)
signal max_health_changed(new_max_health: int)
signal healable_changed(healable: bool)
signal healed(amount: int)
signal invincible_changed(invincible: bool)
signal revivable_changed(revivable: bool)

@export var max_health: int:
	set(f):
		max_health = f
		max_health_changed.emit(max_health)
@export var health: int:
	set(new_health):
		if new_health != health:
			health = clamp(new_health, 0, max_health)
			health_changed.emit(health)
			emit_changed()
			if health <= 0:
				die()

@export var invincible: bool = false:
	set(new_value):
		invincible = new_value
		invincible_changed.emit(invincible)

@export var healable: bool = true:
	set(new_value):
		if healable != new_value:
			healable = new_value
			healable_changed.emit(healable)
			emit_changed()

@export var revivable: bool = false:
	set(new_value):
		if revivable != new_value:
			revivable = new_value
			revivable_changed.emit(revivable)
			emit_changed()

var is_alive := true


func _init(
	max_health: int = 10,
	health: int = 10,
	invincible: bool = false,
	healable: bool = true,
	revivable: bool = false
):
	self.max_health = max_health
	self.health = health
	self.invincible = invincible
	self.healable = healable
	self.revivable = revivable
	is_alive = health > 0
	if health > max_health:
		health = max_health


func set_health_to_max():
	health = max_health


func die():
	is_alive = false
	print("Died")
	healable = false
	died.emit()


func damage(amount: int):
	if not is_alive:
		print("Cannot damage a dead unit")
		return
	if invincible:
		print("Unit is invincible, cannot take damage")
		return
	health -= amount
	damaged.emit(amount)


func heal(amount: int):
	if healable == false:
		print("Unit is not healable")
		return
	health += amount
	healed.emit(amount)


func revive():
	if health > 0:
		print("Unit is already alive")
		return
	if not revivable:
		print("Unit is not revivable")
		return
