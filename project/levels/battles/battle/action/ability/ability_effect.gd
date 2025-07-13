## Base class for effects that can be applied by [AbilityStage]. [br]
## Effects can be logical (HP reduction, position changes) or visual (sprite animations on tiles). [br]
## Multiple [AbilityEffect] objects are defined on an [Ability] and played in sequence with configurable timing. [br]
## Each effect can have its own [TileConstraint] for conditional effects like AoE that can't hurt allies. [br]
class_name AbilityEffect
extends Resource

## Optional constraint that determines if this effect should be applied to the target
@export var constraint: TileConstraint


## Applies this effect to the [GridCell] or [Unit]. [br]
## Override this method in derived classes to implement specific effect behavior. [br]
func apply(_order: ActionExecutionOrder):
	pass
