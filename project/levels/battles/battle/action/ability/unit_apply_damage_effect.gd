## An [AbilityEffect] that applies damage to [Unit] targets. [br]
## Essential for combat abilities that reduce unit health. [br]
## Can be combined with [AreaAbilityEffect] for area-of-effect damage spells.
class_name UnitApplyDamageEffect
extends AbilityEffect

@export var base_damage: int

var damage: int:
	get:
		return base_damage


func _init(_base_damage: int = 0) -> void:
	self.base_damage = _base_damage


## Applies the specified damage to the unit on the target tile. [br]
func apply(_order: ActionExecutionCommand, _return_signal: ReturnSignal):
	pass


func apply_damage_to_health(health: Health, damage: int) -> void:
	if health:
		health.damage(damage)
		emit_signal("damage_applied", health, damage)


func apply_damage_to_unit(unit: Unit, damage: int) -> void:
	if unit:
		apply_damage_to_health(unit.health, damage)
