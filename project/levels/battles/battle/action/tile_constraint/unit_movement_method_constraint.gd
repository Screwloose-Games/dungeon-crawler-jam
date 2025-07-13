## A [TileConstraint] that requires the target [Unit] to have a specific [MovementMethod]. [br]
## Used to restrict movement to only certain [GridCell] based on [MovementMethod]. [br]
## For example, a [MovementMethod] may be Ground, requiring TerrainType.Ground. [br]
class_name UnitMovementMethodConstraint
extends TileConstraint

## The required movement method that the target unit must have
@export var movement_method: Movement.MovementMethod


## Validates that the unit on the target tile has the required movement method. [br]
## [br]
## [b]Returns:[/b] True if the target unit has the required movement method, false otherwise.
func is_valid(_from: BattleGridCell, _to: BattleGridCell):
	pass
