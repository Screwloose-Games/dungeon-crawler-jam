## A [TargetTileConstraint] that requires the target [Unit] to have a specific [StatusEffect]. [br]
## Used for abilities that can only target units with certain conditions like buffs, or debuffs. [br]
class_name UnitStatusEffectConstraint
extends TargetTileConstraint

## The status effect that the target unit must have
@export var status_effect: StatusEffect


## Validates that the unit on the target tile has the required status effect.
func validate(
	_command: ActionExecutionCommand,
	_preview: ActionPreviewData,
):
	pass
