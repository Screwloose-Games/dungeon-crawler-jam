## Base class for rules that determine valid targeting for [Ability] actions. [br]
## Multiple constraints can be defined per ability and all must be satisfied for a tile to be targetable (AND behavior). [br]
## Use [AnyTileConstraint] for OR behavior where any constraint can be satisfied. [br]
## Constraints validate conditions such as terrain types, unit presence, range, status effects, and other tactical conditions. [br]
## Essential for creating precise targeting rules that define tactical ability behavior.
class_name TileConstraint
extends Resource


## Validates whether a target tile is valid for an ability or action. [br]
## Override this method in derived classes to implement specific constraint logic. [br]
## [br]
## [param _from] The source cell where the action originates [br]
## [param _to] The target cell being validated for the action [br]
## [br]
## [b]Returns:[/b] True if the target is valid, false otherwise.
func is_valid(_from: BattleGridCell, _to: BattleGridCell):
	pass
