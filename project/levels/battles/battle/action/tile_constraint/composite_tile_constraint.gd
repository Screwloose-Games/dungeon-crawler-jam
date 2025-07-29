## A [TargetTileConstraint] that provides AND behavior for multiple constraints. [br]
## If all of the listed tile constraints are satisfied, this constraint is valid. [br]
class_name CompositeTileConstraint
extends TargetTileConstraint

## Array of constraints where any one being satisfied makes this constraint valid
@export var constraints: Array[TargetTileConstraint]


func validate(command: ActionExecutionCommand) -> bool:
	for constraint in constraints:
		if not constraint.validate(command):
			return false
	return true


func derive_cells(command: ActionExecutionCommand) -> Variant:
	var cells: Array[BattleGridCell] = []


	return cells


func get_derivation_heuristic() -> float:
	return 0.10
