## Base class for rules that determine valid targeting for [Ability] actions. [br]
## Multiple constraints can be defined per ability and all must be satisfied for a tile to be targetable (AND behavior). [br]
## Use [AnyTargetTileConstraint] for OR behavior where any constraint can be satisfied. [br]
## Constraints validate conditions such as terrain types, unit presence, range, status effects, and other tactical conditions. [br]
## Essential for creating precise targeting rules that define tactical ability behavior.
class_name TargetTileConstraint
extends Resource

## The maximum possible range an attack can have
const MAX_RANGE: int = 15

## Validates whether the target tiles in [param _command] is valid for an ability or action. [br]
## Override this method in derived classes to implement specific constraint logic. [br]
## [br]
## [param preview] should be updated with the details of the validation
func validate(command: ActionExecutionCommand) -> bool:
	for target in command.targets:
		if not _validate_cell(command, target):
			return false
	return true


## Validates whether a specific cell satisfies the [TargetTileConstraint]
## Ignores any targets set on the command
## This function must be overriden on child classes
func _validate_cell(_command: ActionExecutionCommand, _cell: BattleGridCell) -> bool:
	return true


## If possible, provide a list of cells that satisfy the constraint
## Children classes should implement this when the code to do so is trivial
## This is usedas a shortcut so not every cell on the map has to be checked
## If null is returned, cells cannot be derived, otherwise return Array[BattleGridCell]
func derive_cells(_command: ActionExecutionCommand) -> Variant:
	return null


## Get the heuristic that approximates how well the derive_cells function will work
## in terms of narrowing down the search field. The lower the number the better.
## The returned number should approximate the percent of tiles in the map that will meet the tile validation
## For example a range constraint with range of 2 might return .05, as most of the map has been ruled out
## This function should return 1.0 for functions without a derivation implementation
func get_derivation_heuristic() -> float:
	return 1