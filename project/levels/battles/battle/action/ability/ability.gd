## A special power or skill that can be executed by a [Unit] through an [AbilityAction]. [br]
## Can target single or multiple positions on the [Grid] based on [TargetTileConstraint]. [br]
## Executes through multiple stages [AbilityStage] to compose different effects.
class_name Ability
extends Resource

## Display name for this ability
@export var name: String
## Detailed description of what the ability does and how it works
@export_multiline var description: String
## How many individual targets can be selected for this ability
@export var number_of_targets: int
## Rules that determine which tiles can be targeted by this ability
@export var constraints: Array[TargetTileConstraint]
## Sequential phases of execution that define the ability's complete effect over time
@export var stages: Array[AbilityStage]
## The cost in Action Points (AP) to execute this ability
## This is the base cost before any modifications from effects or conditions
@export_range(0, 20, 1) var base_cost: int
@export var targettable_highlight: CellHighlight


func _init(
	name: String = "",
	description: String = "",
	number_of_targets: int = 1,
	constraints: Array[TargetTileConstraint] = [],
	stages: Array[AbilityStage] = [],
	base_cost: int = 0
) -> void:
	self.name = name
	self.description = description
	self.number_of_targets = number_of_targets
	self.constraints = constraints
	self.stages = stages
	self.base_cost = base_cost


func validate(command: ActionExecutionCommand) -> ActionPreviewData:
	var result = ActionPreviewData.new()
	result.action_point_cost += base_cost

	if len(command.targets) < number_of_targets:
		highlight_targetable(command, result)
	return result


func execute(command: ActionExecutionCommand, callback: Callable):
	var return_signal = ReturnSignal.new(callback)
	for stage in stages:
		stage.apply(command, return_signal)
	return_signal.all_participants_registered()


func get_minimum_ap_cost():
	return base_cost


func highlight_targetable(
	command: ActionExecutionCommand,
	preview: ActionPreviewData
):
	var targetable = get_targetable_cells(command)
	for cell in targetable:
		preview.highlighted_cells[cell.position] = targettable_highlight


func get_targetable_cells(command: ActionExecutionCommand) -> Array[BattleGridCell]:
	var cells = command.battle_grid.get_cells()
	var valid_cells: Array[BattleGridCell] = []

	var tile_command = command.clone()
	var tile_preview = ActionPreviewData.new()

	for cell in cells:
		var valid = true
		tile_command.targets = [cell]
		for constraint in constraints:
			tile_preview.clear()
			constraint.validate(command, tile_preview)
			if not tile_preview.valid:
				valid = false
				break
		if valid:
			valid_cells.append(cell)
	return valid_cells
