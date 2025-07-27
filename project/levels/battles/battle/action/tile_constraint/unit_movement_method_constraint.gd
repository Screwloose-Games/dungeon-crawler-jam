## A [TargetTileConstraint] that requires the target [Unit] to have a specific [MovementMethod]. [br]
## Used to restrict movement to only certain [GridCell] based on [MovementMethod]. [br]
## For example, a [MovementMethod] may be Ground, requiring TerrainType.Ground. [br]
class_name UnitMovementMethodConstraint
extends TargetTileConstraint

## The required movement method that the target unit must have
@export var movement_method: Movement.MovementMethod


## Validates that the unit on the target tile has the required movement method.
func _validate_cell(command: ActionExecutionCommand, cell: BattleGridCell) -> bool:
	return cell.unit.movement.method == movement_method


func get_error_message(method: Movement.MovementMethod) -> String:
	match method:
		Movement.MovementMethod.FLY:
			return tr("not_flying")
		Movement.MovementMethod.WALK:
			return tr("not_walking")
		Movement.MovementMethod.JUMP:
			return tr("not_jumping")
		_:
			assert(false, "Movement method not implemented")
			return "invalid_move_method"
