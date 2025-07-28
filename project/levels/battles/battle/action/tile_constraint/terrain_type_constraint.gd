## A [TargetTileConstraint] that requires the target tile to be of a set of specific terrain type. [br]
## Used to restrict abilities to certain terrain like requiring ground for slamming or walls to slam against. [br]
class_name TerrainTypeConstraint
extends TargetTileConstraint

## The required terrain types that the target tile must have
@export var valid_types: Array[BattleGridCell.TileType]


## Validates that the target tile matches the required terrain type.
func _validate_cell(_command: ActionExecutionCommand, cell: BattleGridCell) -> bool:
	return valid_types.find(cell.type) >= 0
