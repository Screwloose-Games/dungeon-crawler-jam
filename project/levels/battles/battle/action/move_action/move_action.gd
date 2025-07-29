## A [UnitAction] that allows a [Unit] to move across the [Grid]. [br]
## Respects terrain constraints and other units' positions on the [Grid].
# TODO: This class should be replaced in favor of MoveAbility
class_name MoveAction
extends UnitAction

## The movement capabilities and constraints for this movement action
@export var movement: Movement
var _tile_constraints: Array[TargetTileConstraint]


func _init(
	_name: String = "Move",
	_description: String = "Move the unit to a new position.",
	_movement: Movement = null,
	_tile_constraints: Array[TargetTileConstraint] = []
):
	var unit_not_present = UnitPresentTargetTileConstraint.new(true)
	var navigable = NavigableConstraint.new()
	self._tile_constraints = [unit_not_present, navigable]

	super (_name, _description, 0)

	targettable_highlight = CellHighlight.new(
		CellHighlight.HighlightColor.WHITE,
		CellHighlight.Type.CORNER
	)


func preview(command: ActionExecutionCommand) -> ActionPreviewData:
	var result = ActionPreviewData.new()
	var path = get_movement_path(command)
	if not path:
		return null

	result.action_point_cost = get_ap_cost_from_path(command, path)
	result.path_tiles = path.get_path_orientations()
	return result


func execute(command: ActionExecutionCommand, callback: Callable):
	var path = get_movement_path(command)
	assert(path, "Invalid path")
	var unit = command.unit

	var ap_cost = get_ap_cost_from_path(command, path)
	unit.spend_action_points(ap_cost)
	unit.movement.purchase_movement(path.move_count)
	command.unit.move_along_path(path, callback)


func validate(command: ActionExecutionCommand) -> bool:
	var path = get_movement_path(command)
	if not path or len(path.cell_path) == 0:
		return false
	if path.cell_path[-1] != command.targets[0]:
		return false

	return super.validate(command)


func get_movement_path(command: ActionExecutionCommand) -> MovementPath:
	if not command.targets or len(command.targets) != 1:
		return null

	var path_start = command.unit.cell
	var path_end = command.targets[0]
	var move_method = command.unit.movement.method
	var path = command.battle_grid.get_movement_path(path_start, path_end, move_method)
	return path


func get_ap_cost(command: ActionExecutionCommand) -> int:
	var movement_path = get_movement_path(command)
	return get_ap_cost_from_path(command, movement_path)


# Movement could be free due to accrued movement points
func get_minimum_ap_cost() -> int:
	return 0


func get_ap_cost_from_path(command: ActionExecutionCommand, movement_path: MovementPath) -> int:
	if not movement_path:
		return 0
	return command.unit.movement.get_ap_required_to_move(movement_path.move_count)


func get_targetable_highlight(
	_command: ActionExecutionCommand,
	_cell: BattleGridCell
) -> CellHighlight:
	return CellHighlight.new(
		CellHighlight.HighlightColor.GREEN,
		CellHighlight.Type.FULL
	)


func get_tile_constraints() -> Array[TargetTileConstraint]:
	return _tile_constraints
