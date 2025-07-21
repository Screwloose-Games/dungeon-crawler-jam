## A [UnitAction] that allows a [Unit] to move across the [Grid]. [br]
## Respects terrain constraints and other units' positions on the [Grid].
# TODO: This class should be replaced in favor of MoveAbility
class_name MoveAction
extends UnitAction

## The movement capabilities and constraints for this movement action
@export var movement: Movement

var tile_constraints: Array[TargetTileConstraint] = []

func _init(
	_name: String = "Move",
	_description: String = "Move the unit to a new position.",
	_base_cost: int = 0,
	_movement: Movement = null
):
	super (_name, _description, _base_cost)

	var unit_present_constraint = UnitPresentTargetTileConstraint.new()
	unit_present_constraint.invert = true

	var navigable_constraint = NavigableConstraint.new()

	tile_constraints = [unit_present_constraint, navigable_constraint]


func get_constraints() -> Array[TargetTileConstraint]:
	return tile_constraints


func preview(command: ActionExecutionCommand) -> ActionPreviewData:
	var path = get_movement_path(command)
	if not path:
		return null

	var preview: ActionPreviewData = ActionPreviewData.new()
	preview.path_tiles = path.get_path_orientations()

	return preview


func execute(command: ActionExecutionCommand, callback: Callable):
	var path = get_movement_path(command)
	assert(path != null, "Invalid path")
	command.unit.move_along_path(path, callback)


func get_movement_path(command: ActionExecutionCommand) -> MovementPath:
	var path_start = command.unit.cell
	var path_end = command.targets[0]
	var move_method = command.unit.movement.method
	var path = command.battle_grid.get_movement_path(path_start, path_end, move_method)
	return path
