@tool
## An individual, controllable object on the [Grid]. The [Unit] can receive commands [br]
## from their [Commander] to execute an [UnitAction] via an [ActionExecutionCommand]
class_name Unit
extends Resource

signal died
signal moved_to(new_cell: BattleGridCell)

@export var name: String:
	set(new_value):
		if name != new_value:
			name = new_value
			emit_changed()

@export_multiline var description: String

## Abilities are things like spells or special actions.
@export var abilities: Array[Ability] = []:
	set(val):
		if val != abilities:
			emit_changed()
			abilities = val
			init_actions()
@export var movement: Movement

## The maximum amount of Action Points this [Unit] can have.[br]
## These are spent to execute an [Action] based on [Action] cost.
@export var action_points_max: int

## Includes the animations such as `hit_react` and `death`.
@export var sprite_frames: SpriteFrames:
	set(new_value):
		if sprite_frames != new_value:
			sprite_frames = new_value
			emit_changed()

## Used in the UI when illustrating the unit.

@export var portrait: Texture2D

## Cell movement per second
@export var move_speed: float = 0.5

@export var health_point_max: int = 10:
	set(new_value):
		if health_point_max != new_value:
			health_point_max = new_value
			health.maximum = health_point_max
			emit_changed()

@export var health_points: int = 10:
	set(new_value):
		if health_points != new_value:
			health_points = new_value
			health.current = health_points
			emit_changed()

var health: Health:
	set(new_health):
		if health != new_health:
			health = new_health
			emit_changed()
			if health:
				# if not connected, connect the health signals
				if not health.died.is_connected(_on_health_died):
					health.died.connect(_on_health_died)
				if not health.health_changed.is_connected(_on_health_health_changed):
					health.health_changed.connect(_on_health_health_changed)
				if not health.maximum_changed.is_connected(_on_health_maximum_changed):
					health.maximum_changed.connect(_on_health_maximum_changed)

## The actions that the unit can take.
## Units typically have a move action and ways to attack.
## An action can be to move, use an item, use an ability.
var actions: Array[UnitAction]:
	set(val):
		actions = val
		emit_changed()

var action_points_current: int = 0

var cell: BattleGridCell:
	set(new_cell):
		if cell == new_cell:
			return
		# Removing cell
		if not new_cell and cell:
			cell.unit = null
			cell = new_cell
			return
		# Remove self from previous cell
		if cell and cell.unit == self:
			cell.unit = null

		cell = new_cell
		# Add self to new cell
		cell.unit = self
		moved_to.emit(cell)

var team: Team:
	set(new_value):
		if new_value == team:
			return
		if team:
			GlobalSignalBus.unit_removed_from_team.emit(self, team)
		team = new_value
		if team:
			GlobalSignalBus.unit_added_to_team.emit(self, team)


func _on_health_health_changed(new_health: int):
	health_points = new_health


func _on_health_maximum_changed(new_maximum: int):
	health_point_max = new_maximum


func _on_health_died():
	die()


func die():
	died.emit()
	cell = null
	team = null


func _init(
	name: String = "",
	description: String = "",
	abilities: Array[Ability] = [],
	movement: Movement = null,
	action_points_max: int = action_points_max,
	sprite_frames: SpriteFrames = null,
	portrait: Texture2D = null,
	actions: Array[UnitAction] = [],
	current_grid_cell: BattleGridCell = null,
	health: Health = null
) -> void:
	self.name = name
	self.description = description
	self.abilities = abilities
	self.movement = movement
	self.action_points_max = action_points_max
	self.sprite_frames = sprite_frames
	self.portrait = portrait
	self.actions = actions
	self.cell = current_grid_cell
	self.health = health if health else Health.new(health_point_max, health_point_max)
	changed.connect(init_actions)


func init_actions():
	var new_actions = init_ability_actions()
	if new_actions.size() > 0:
		for action in new_actions:
			if action not in actions:
				actions.append(action)


func init_move_action():
	if movement:
		var action: MoveAction = MoveAction.new()
		action.movement = movement
		actions.append(action)


func init_ability_actions() -> Array[AbilityAction]:
	var ability_actions: Array[AbilityAction] = []
	for ability in abilities:
		var action = AbilityAction.new()
		action.ability = ability
		action.base_cost = ability.base_cost
		ability_actions.append(action)
	return ability_actions


func add_action(action: UnitAction) -> void:
	if action not in actions:
		actions.append(action)
		emit_changed()


## Return all the actions this unit can execute.[br]
## Units have 1 action per ability, plus a move action.
## [br]
## [b]Returns:[/b] An array of [UnitAction] that this unit
func get_actions() -> Array[UnitAction]:
	return actions


## Returns all actions that can be executed based on available AP and AP cost.
func get_available_actions() -> Array[UnitAction]:
	return actions.filter(can_execute_action)


## Determines if the unit can execute a specific action based on its AP. [br]
func can_execute_action(action: UnitAction) -> bool:
	return action.cost <= action_points_current


## Does not have complete validation, specifically considering movement type
func move_to_cell(target_cell: BattleGridCell) -> bool:
	if not target_cell:
		return false

	if target_cell.unit and target_cell.unit != self:
		return false

	if cell:
		cell.unit = null
	cell = target_cell
	target_cell.unit = self

	return true


func damage(amount: int) -> void:
	if health:
		health.damage(amount)


func heal(amount: int) -> void:
	if health:
		health.heal(amount)
