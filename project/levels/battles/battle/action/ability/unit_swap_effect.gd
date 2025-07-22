## An [AbilityEffect] that swaps the positions of units in the [Grid]. [br]
## Used for position manipulation abilities. [br]
## Can be used with [TargetTileConstraint] to ensure valid swap targets and destinations.
class_name UnitSwapEffect
extends AbilityEffect


## Swaps the positions of units between two tiles on the battlefield. [br]
func apply(_order: ActionExecutionCommand, _return_signal: ReturnSignal):
	pass
