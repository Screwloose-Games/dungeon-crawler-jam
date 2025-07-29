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

var tile_constraints: Array[TargetTileConstraint]:
	get = get_tile_constraints

var targettable_highlight = CellHighlight.new(
	CellHighlight.HighlightColor.RED,
	CellHighlight.Type.FULL,
)


## Note: Will be Overridden later by any @export values set.
func _init(
	name: String = "",
	description: String = "",
	minimum_ap_cost: int = 0
) -> void:
	self.name = name
	self.description = description
	self.minimum_ap_cost = minimum_ap_cost


func get_tile_constraints() -> Array[TargetTileConstraint]:
	return []


func get_targetable_highlights(
	command: ActionExecutionCommand
) -> Dictionary[Vector2i, CellHighlight]:
	var highlights: Dictionary[Vector2i, CellHighlight] = {}

	var targetable = get_targetable_cells(command)
	for cell in targetable:
		highlights[cell.position] = get_targetable_highlight(command, cell)

	return highlights


## Get any data needed to preview the result, such as highlighted and targetted tiles, AP cost, path
func preview(command: ActionExecutionCommand) -> ActionPreviewData:
	var result = ActionPreviewData.new()
	result.action_point_cost = get_ap_cost(command)

	return result


## Execute the command given the [param command].
## The unit's AP will be spent, and the [param callback] will be called up completion
func execute(_command: ActionExecutionCommand, _callback: Callable):
	assert(false, "child class must implement execute")


## Validate that target constraints and ap cost are satisfied
func validate(command: ActionExecutionCommand) -> bool:
	for constraint in tile_constraints:
		if not constraint.validate(command):
			return false

	# If constraints are satisfied, check ap
	return command.can_unit_afford()


## Determine which cells are targetable
## Takes into consideration which cells are already targetted by this command
func get_targetable_cells(command: ActionExecutionCommand) -> Array[BattleGridCell]:
	var cells: Array[BattleGridCell]
	var valid_cells: Array[BattleGridCell] = []

	var derived_cells = _attempt_cell_derivation(command)
	if derived_cells:
		cells = derived_cells
	else:
		cells = command.battle_grid.get_cells()

	# copy of the current command so we can mutate
	# the targets without worrying about side effects
	var mock_command = command.clone()

	for cell in cells:
		mock_command.targets.clear()
		mock_command.targets.append(cell)
		if validate(mock_command):
			valid_cells.append(cell)

	return valid_cells


## Given the constraints of this action, derive the potential list of cells
## Returns null if no cells can be derived
func _attempt_cell_derivation(command: ActionExecutionCommand) -> Variant:
	for constraint in tile_constraints:
		var derived_cells = constraint.derive_cells(command)
		if derived_cells:
			return derived_cells
	return null


## Get the cell highlight for the [param cell]
## Can be overriden by children classes to provide custom targetable visuals
func get_targetable_highlight(
	_command: ActionExecutionCommand, _cell: BattleGridCell
) -> CellHighlight:
	return targettable_highlight


## The actual AP cost of this action given the [param command]
func get_ap_cost(_command: ActionExecutionCommand) -> int:
	assert(false, "child class must implement get_ap_cost")
	return 0


## The minimum required AP to use this action
func get_minimum_ap_cost() -> int:
	return minimum_ap_cost
