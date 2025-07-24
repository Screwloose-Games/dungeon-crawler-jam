## Represents a specific command issued by a [Commander] to execute a [UnitAction]. [br]
## Links a commanding [Commander] to a target [Unit] and the specific [UnitAction] to perform. [br]
## Encapsulates the complete context needed to execute an [Action].
class_name ActionExecutionCommand
extends Resource

@export var unit: Unit
@export var commander: Commander
@export var action: UnitAction
@export var targets: Array[BattleGridCell]
var battle_grid: BattleGrid

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
	targets: Array[BattleGridCell] = []
) -> void:
	self.unit = unit
	self.commander = commander
	self.action = action
	self.targets = targets
	self.battle_grid = battle_grid
	team = commander.team if commander else null


func is_on_same_team(commander: Commander, unit: Unit) -> bool:
	return commander and unit and commander.team == unit.team


func can_command_unit(unit: Unit) -> bool:
	# Check if the commander can command the unit
	return commander and is_on_same_team(commander, unit)


func execute(callback: Callable) -> bool:
	var preview_data = validate()
	if not preview_data.valid:
		callback.call(false)
		return false

	action.execute(self, callback)
	return true


func validate() -> ActionPreviewData:
	assert(unit, "Unit is not set")
	assert(commander, "Commander is not set")
	assert(action, "Action is not set")

	var result = ActionPreviewData.new()
	result = action.validate(self)

	return result
