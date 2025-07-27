## Base class for effects that can be applied by [AbilityStage]. [br]
## Effects can be logical (HP reduction, position changes) or visual (sprite animations on tiles). [br]
## Multiple [AbilityEffect] objects are defined on an [Ability] and played in sequence with configurable timing. [br]
## Each effect can have its own [TargetTileConstraint] for conditional effects like AoE that can't hurt allies. [br]
class_name AbilityEffect
extends Resource

## Optional constraint that determines if this effect should be applied to the target
@export var constraint: TargetTileConstraint


func preview(_command: ActionExecutionCommand, _preview: ActionPreviewData):
	pass


## Applies this effect to the [BattleGridCell] or [Unit]. [br]
## Override this method in derived classes to implement specific effect behavior. [br]
func apply(_order: ActionExecutionCommand, _return_signal: ReturnSignal):
	pass


func get_additional_ap_cost(_command: ActionExecutionCommand) -> int:
	return 0


func get_duration() -> float:
	return 0.0
