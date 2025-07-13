## An [AbilityEffect] that applies damage to [Unit] targets. [br]
## Essential for combat abilities that reduce unit health. [br]
## Can be combined with [AreaAbilityEffect] for area-of-effect damage spells.
class_name UnitApplyDamageEffect
extends AbilityEffect


## Applies the specified damage to the unit on the target tile. [br]
func apply(_order: ActionExecutionOrder):
	pass
