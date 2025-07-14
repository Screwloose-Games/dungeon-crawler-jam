@tool
## An individual, controllable object on the [Grid]. The [Unit] can receive commands [br]
## from their [Commander] to execute an [UnitAction] via an [ActionExecutionCommand]
class_name Unit
extends Resource

signal died

@export var name: String:
	set(new_value):
		if name != new_value:
			name = new_value
			emit_changed()

@export_multiline var description: String

## Abilities are things like spells or special actions.
@export var abilities: Array[Ability]
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

## The actions that the unit can take.
## Units typically have a move action and ways to attack.
## An action can be to move, use an item, use an ability.
@export var actions: Array[UnitAction]

var action_points_current: int = action_points_max


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


func hurt():
	died.emit()


func execute_action(_action: UnitAction):
	pass
