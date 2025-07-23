## Base class for actions that can be performed by a [Unit] on a [Battlefield]. [br]
## Unit actions represent the various commands that a [Commander] can give to their [Unit], [br]
## such as movement, attacks, abilities, or using an [Item]. [br]
## Each [Action] has an associated cost that determines how many Action Points (AP) it requires to execute.
class_name UnitAction
extends Resource

@export var name: String
@export_multiline var description: String

## The base cost required to execute this action. [br]
## Used as part of the calculation for cost, [member cost].
@export var minimum_ap_cost: int
@export var tile_constraints: Array[TargetTileConstraint]


## Note: Will be Overridden later by any @export values set.
func _init(
	name: String = "",
	description: String = "",
	minimum_ap_cost: int = 0,
	tile_constraints: Array[TargetTileConstraint] = []
) -> void:
	self.name = name
	self.description = description
	self.minimum_ap_cost = minimum_ap_cost
	self.tile_constraints = tile_constraints


func get_minimum_ap_cost() -> int:
	return minimum_ap_cost


## Validate whether or not an action is possible
## If possible, the ActionPreviewData returned should include any data needed to preview
## the result, such as highlighted and targetted tiles, AP cost, path
## If not possible, the ActionPreviewData should include a reason, and may optionally provide
## other preview data to be displayed if desired
func validate(command: ActionExecutionCommand) -> ActionPreviewData:
	var result = ActionPreviewData.new()
	result.action_point_cost = get_minimum_ap_cost()

	check_unit_ap(command, result)
	check_target_constraints(command, result)

	return result


func execute(command: ActionExecutionCommand, callback: Callable):
	var preview = validate(command)
	if preview.valid:
		command.unit.spend_action_points(preview.action_point_cost)
		callback.call()


## Check TileTargetConstraints, update [param preview_data] with any errors
func check_target_constraints(
	command: ActionExecutionCommand,
	preview_data: ActionPreviewData,
):
	for constraint in tile_constraints:
		constraint.validate(command, preview_data)


# Check if unit can afford the ap cost
func check_unit_ap(command: ActionExecutionCommand, preview_data: ActionPreviewData):
	if command.unit.action_points_current < preview_data.action_point_cost:
		preview_data.add_error(tr("cannot_afford"))
