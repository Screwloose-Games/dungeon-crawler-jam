## A [TileConstraint] that requires a [Unit] to be present on the target tile. [br]
## Essential for abilities that must target occupied cells, such as healing or attack spells. [br]
## When multiple [TileConstraint] objects are used, all must be satisfied (AND behavior). [br]
## Use [AnyTileConstraint] if you need OR behavior with other constraints.
class_name UnitPresentTileConstraint
extends TileConstraint


## Validates that a unit is present on the target tile. [br]
## [br]
## [b]Returns:[/b] True if a unit is present on the target tile, false otherwise.
func is_valid(_from: BattleGridCell, _to: BattleGridCell):
	pass
