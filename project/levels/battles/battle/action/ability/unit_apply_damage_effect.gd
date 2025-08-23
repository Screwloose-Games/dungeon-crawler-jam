## An [AbilityEffect] that applies damage to [Unit] targets. [br]
## Essential for combat abilities that reduce unit health. [br]
## Can be combined with [AreaAbilityEffect] for area-of-effect damage spells.
class_name UnitApplyDamageEffect
extends AbilityEffect

signal damage_applied(health: Health, damage: int)

@export var base_damage: int

var damage: int:
	get:
		return base_damage


func _init(_base_damage: int = 0) -> void:
	self.base_damage = _base_damage
	self.does_damage = true


func preview(command: ActionExecutionCommand, preview: ActionPreviewData):
	for target in command.targets:
		preview.highlighted_cells[target.position] = target_highlight


## Applies the specified damage to the unit on the target tile. [br]
func apply(
	command: ActionExecutionCommand,
	wait_request: WaitRequest,
	reactions: Array[Callable],
):
	var attacking_unit = command.unit
	for target in command.targets:
		if target.unit:
			print("calling unit damage")
			target.unit.damage(damage, command, reactions)
