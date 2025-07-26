## A [UnitAction] that allows a [Unit] to move across the [Grid]. [br]
## Respects terrain constraints and other units' positions on the [Grid].
# TODO: This class should be replaced in favor of MoveAbility
class_name MoveAction
extends UnitAction

## The movement capabilities and constraints for this movement action
@export var movement: Movement

func _init(
	_name: String = "Move",
	_description: String = "Move the unit to a new position.",
	_movement: Movement = null,
	_tile_constraints: Array[TargetTileConstraint] = []
):
	var unit_present_constraint = UnitPresentTargetTileConstraint.new(true)
	var navigable_constraint = NavigableConstraint.new()
	tile_constraints = [unit_present_constraint, navigable_constraint]

	super (_name, _description, 0, tile_constraints)


func preview(command: ActionExecutionCommand) -> ActionPreviewData:
	var result = super.preview(command)

	if not result.valid:
		return result

	var path = get_movement_path(command)
	assert(path, "Could not path to tile despite NavigableConstraint")

	result.action_point_cost = command.unit.movement.get_required_ap_to_move(path.move_count)
	check_unit_ap(command, result)

	result.path_tiles = path.get_path_orientations()

	return result


func execute(command: ActionExecutionCommand, callback: Callable):
	var preview = preview(command)

	var path = get_movement_path(command)
	assert(path != null, "Invalid path")
	var unit = command.unit

	unit.spend_action_points(preview.action_point_cost)
	unit.movement.purchase_movement(path.move_count)
	command.unit.move_along_path(path, callback)


func get_movement_path(command: ActionExecutionCommand) -> MovementPath:
	var path_start = command.unit.cell
	var path_end = command.targets[0]
	var move_method = command.unit.movement.method
	var path = command.battle_grid.get_movement_path(path_start, path_end, move_method)
	return path
