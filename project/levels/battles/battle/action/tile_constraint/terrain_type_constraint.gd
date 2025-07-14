## A [TargetTileConstraint] that requires the target tile to be of a set of specific terrain type. [br]
## Used to restrict abilities to certain terrain like requiring ground for slamming or walls to slam against. [br]
class_name TerrainTypeConstraint
extends TargetTileConstraint

## The required terrain types that the target tile must have
@export var valid_types: Array[Battlefield.TileType]


## Validates that the target tile matches the required terrain type. [br]
## [br]
## [b]Returns:[/b] True if the target tile has the required terrain type, false otherwise.
func is_valid(_command: ActionExecutionCommand):
	pass
