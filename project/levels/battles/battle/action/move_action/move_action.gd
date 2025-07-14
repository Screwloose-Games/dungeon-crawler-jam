## A [UnitAction] that allows a [Unit] to move across the [Grid]. [br]
## Respects terrain constraints and other units' positions on the [Grid].
class_name MoveAction
extends UnitAction

## The movement capabilities and constraints for this movement action
@export var movement: Movement
