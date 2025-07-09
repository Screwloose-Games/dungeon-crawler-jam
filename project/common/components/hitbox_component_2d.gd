@tool
extends ComponentArea2D
class_name HitBoxComponent2D

signal hit(hurt_box: HurtBoxComponent2D)

## the owner of the hit box
@export var sender: Node2D = owner
## the value the hit sends
@export var amount: float
## the amount of time that needs to pass before the hit_box can hit a single hurtbox after a hit
@export var cooldown: float
## if true hit box will deactivate after a hit
@export var deactivate_on_hit: bool
## if true the hit box will activate and then deactivate immediately
@export var is_one_shot: bool:
	set(b):
		is_one_shot = b
		prints("one shot", b)
## when true the hitbox is monitoring, when false the hitbox is not monitoring
@export var active: bool = monitoring:
	set(b):
		if b == true:
			activate()
		else:
			deactivate()
	get:
		return monitoring

## {<hurtbox: Node2D> : <cooldown: float>}
var hits_on_cooldown: Dictionary = {}


func activate() -> void:
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	monitoring = true


func deactivate() -> void:
	if area_entered.is_connected(_on_area_entered):
		area_entered.disconnect(_on_area_entered)
	monitoring = false


func one_shot() -> void:
	var overlapping_hurtboxes = get_overlapping_areas()
	#await get_tree().process_frame
	for area in overlapping_hurtboxes:
		if area is HurtBoxComponent2D:
			area.apply_hurt(sender, amount)
	#if not is_one_shot:dw
	#is_one_shot = true
	#activate()
	#else:
	#is_one_shot = false
	#deactivate()


func is_hit_on_cooldown(hurt_box: HurtBoxComponent2D):
	if hits_on_cooldown.has(hurt_box):
		return true
	return false


# possibly refactor to use Array.map
func decrement_hits_on_cooldown(delta):
	if hits_on_cooldown.is_empty():
		return
	for key in hits_on_cooldown.keys():
		if hits_on_cooldown[key] <= 0:
			hits_on_cooldown.erase(key)
			continue
		hits_on_cooldown[key] -= delta


func apply_hit(hurt_box: HurtBoxComponent2D) -> void:
	if is_hit_on_cooldown(hurt_box):
		return
	hits_on_cooldown.merge({hurt_box: cooldown})
	hurt_box.apply_hurt(sender, amount)
	hit.emit(hurt_box)
	if deactivate_on_hit == false:
		return
	deactivate()


func _process(delta: float) -> void:
	decrement_hits_on_cooldown(delta)


func _on_area_entered(area) -> void:
	if is_one_shot:
		return
	if not (area as HurtBoxComponent2D):
		return
	apply_hit(area)


func _physics_process(delta: float) -> void:
	decrement_hits_on_cooldown(delta)
