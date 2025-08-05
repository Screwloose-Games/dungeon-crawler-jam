## A [TargetTileConstraint] that requires the target [Unit] to have a specific [MovementMethod]. [br]
## Used to restrict movement to only certain [GridCell] based on [MovementMethod]. [br]
## For example, a [MovementMethod] may be Ground, requiring TerrainType.Ground. [br]
class_name UnitMovementMethodConstraint
extends TargetTileConstraint

## The required movement method that the target unit must have
@export var movement_method: Movement.Method


## Validates that the unit on the target tile has the required movement method.
func _validate_cell(_command: ActionExecutionCommand, cell: BattleGridCell) -> bool:
	return cell.unit.movement.method == movement_method
