## A [UnitAction] that allows a [Unit] to move across the [Grid]. [br]
## Respects terrain constraints and other units' positions on the [Grid].
class_name MoveAction
extends UnitAction

## The movement capabilities and constraints for this movement action
@export var movement: Movement


func _init(
	_name: String = "Move",
	_description: String = "Move the unit to a new position.",
	_base_cost: int = 1,
	_movement: Movement = null
):
	super (_name, _description, _base_cost)


func preview(command: ActionExecutionCommand) -> ActionPreviewData:
	# Must have a valid command with a unit with cell position and movement
	if not command or not command.unit or not command.unit.cell or not command.unit.movement:
		return

	var path_start = command.unit.cell
	var path_end = command.targets[0]
	var move_method = command.unit.movement.method

	var path = command.battle_grid.get_movement_path(path_start, path_end, move_method)
	if not path:
		return

	var preview: ActionPreviewData = ActionPreviewData.new()
	preview.path_tiles = path.get_path_orientations()

	return preview
