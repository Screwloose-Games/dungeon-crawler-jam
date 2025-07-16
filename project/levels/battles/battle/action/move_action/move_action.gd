## A [UnitAction] that allows a [Unit] to move across the [Grid]. [br]
## Respects terrain constraints and other units' positions on the [Grid].
class_name MoveAction
extends UnitAction

## The movement capabilities and constraints for this movement action
@export var movement: Movement


func _init(
	_name: String = "Move",
	_description: String = "Move the unit to a new position.",
	_base_cost: int = 1,
	_movement: Movement = null
):
	super(_name, _description, _base_cost)
