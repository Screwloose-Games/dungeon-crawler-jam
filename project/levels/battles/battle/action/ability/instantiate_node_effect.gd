## An [AbilityEffect] that instantiates a node on the target [GridCell] of the [Grid]. [br]
## Used for summoning units, creating fire animation sprites, or spawning environmental objects. [br]
class_name InstantiateNodeEffect
extends AbilityEffect

## The scene to instantiate on the target tile
@export var node_to_create: PackedScene


## Instantiates the specified node at the target tile position. [br]
func apply(_order: ActionExecutionCommand):
	pass
