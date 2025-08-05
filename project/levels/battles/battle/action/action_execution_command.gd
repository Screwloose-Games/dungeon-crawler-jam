## Represents a specific command issued by a [Commander] to execute a [UnitAction]. [br]
## Links a commanding [Commander] to a target [Unit] and the specific [UnitAction] to perform. [br]
## Encapsulates the complete context needed to execute an [Action].
class_name ActionExecutionCommand
extends Resource

signal completed

static var running_command: ActionExecutionCommand

@export var unit: Unit
@export var commander: Commander
@export var action: UnitAction
@export var targets: Array[BattleGridCell]

## Where the command originated from
## Almost always the position of the unit, but can be overriden with override_origin()
var origin_position: Vector2i:
	get:
		if _overriden_origin == null:
			if unit and unit.cell:
				return unit.cell.position
			return Vector2i.ZERO
		return _overriden_origin

var battle_grid: BattleGrid
var _overriden_origin: Variant = null

var team: Team:
	set(new_value):
		if team != new_value:
			team = new_value
			emit_changed()


func _init(
	unit: Unit = null,
	commander: Commander = null,
	battle_grid: BattleGrid = null,
	action: UnitAction = null,
	targets: Array[BattleGridCell] = [],
) -> void:
	self.unit = unit
	self.commander = commander
	self.action = action
	self.targets = targets
	self.battle_grid = battle_grid
	team = commander.team if commander else null


func clone() -> ActionExecutionCommand:
	return ActionExecutionCommand.new(
		unit,
		commander,
		battle_grid,
		action,
		targets.duplicate()
	)


func execute(callback: Callable):
	assert(not running_command, "Already running a different command")

	running_command = self
	GlobalSignalBus.command_started.emit(self)
	action.execute(self, _on_command_completed.bind(callback))
	running_command = null


func execute_and_wait():
	var completed_flag: Array[bool] = [false]
	execute(func(): completed_flag[0] = true)

	# Catch if command is completed immediately
	if completed_flag[0]:
		return

	await completed


func preview() -> ActionPreviewData:
	if not is_complete():
		return null

	assert(unit, "Unit is not set")
	assert(commander, "Commander is not set")
	assert(action, "Action is not set")

	var result = ActionPreviewData.new()
	result = action.preview(self)

	return result


## Validate the tile constraints and AP cost
func validate() -> bool:
	return action.validate(self)


func _on_command_completed(callback: Callable):
	GlobalSignalBus.command_completed.emit(self)
	callback.call()
	completed.emit()


func is_complete():
	return unit and commander and action


## determine if the unit can afford the action
func can_unit_afford() -> bool:
	return unit.action_points_current >= action.get_ap_cost(self)


func get_targetable_highlights() -> Dictionary[Vector2i, CellHighlight]:
	return action.get_targetable_highlights(self)


func is_on_same_team(commander: Commander, unit: Unit) -> bool:
	return commander and unit and commander.team == unit.team


func can_command_unit(unit: Unit) -> bool:
	# Check if the commander can command the unit
	return commander and is_on_same_team(commander, unit)


func override_origin(new_origin: Vector2i) -> void:
	_overriden_origin = new_origin
