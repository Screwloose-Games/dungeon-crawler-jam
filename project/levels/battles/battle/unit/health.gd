class_name Health
extends Resource

signal died
signal health_changed(new_health: int)
signal damaged(amount: int)
signal maximum_changed(new_maximum: int)
signal healable_changed(healable: bool)
signal healed(amount: int)
signal invincible_changed(invincible: bool)
signal revivable_changed(revivable: bool)

@export var maximum: int:
	set(f):
		maximum = f
		maximum_changed.emit(maximum)
@export var current: int:
	set(new_current):
		if new_current != current:
			current = clamp(new_current, 0, maximum)
			health_changed.emit(current)
			emit_changed()
			if current <= 0:
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

var is_alive: bool = true
var is_dead: bool:
	get:
		return !is_alive


func _init(
	maximum: int = 10,
	current: int = 10,
	invincible: bool = false,
	healable: bool = true,
	revivable: bool = false
):
	self.maximum = maximum
	self.current = current
	self.invincible = invincible
	self.healable = healable
	self.revivable = revivable
	is_alive = current > 0
	if current > maximum:
		current = maximum


func set_current_to_maximum():
	current = maximum


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
	current -= amount
	damaged.emit(amount)


func heal(amount: int):
	if healable == false:
		print("Unit is not healable")
		return
	current += amount
	healed.emit(amount)


func revive():
	if current > 0:
		print("Unit is already alive")
		return
	if not revivable:
		print("Unit is not revivable")
		return
