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


func is_valid() -> bool:
	var is_valid: bool = true
	is_valid = is_valid and unit != null
	is_valid = is_valid and commander != null
	is_valid = is_valid and action != null
	is_valid = is_valid and targets.size() > 0
	is_valid = is_valid and satisfies_action_constraints()
	is_valid = is_valid and can_afford_cost()
	return is_valid


func can_afford_cost() -> bool:
	return action.cost <= unit.action_points_current


func satisfies_action_constraints() -> bool:
	if action and action.constraints:
		for constraint in action.constraints:
			if not constraint.is_valid(self):
				return false
	return true


func execute():
	if not unit:
		push_error("ActionExecutionCommand has no unit assigned.")
	if not commander:
		push_error("ActionExecutionCommand has no commander assigned.")
	if not action:
		push_error("ActionExecutionCommand has no action assigned.")
	if not is_valid():
		push_error("Invalid ActionExecutionCommand: " + str(self))
		return
	spend_action_points()


func spend_action_points():
	unit.action_points_current -= action.cost
