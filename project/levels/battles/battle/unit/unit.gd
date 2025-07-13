@tool
## An individual, controllable object on the [Grid]. The [Unit] can receive commands [br]
## from their [Commander] to execute an [UnitAction] via an [ActionExecutionOrder]
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

## Includes the animations such as `hit_react` and `death`.
@export var sprite_frames: SpriteFrames:
	set(new_value):
		if sprite_frames != new_value:
			sprite_frames = new_value
			emit_changed()
@export var portrait: Texture2D

## The actions that the unit can take.
## Units typically have a move action and ways to attack.
## An action can be to move, use an item, use an ability.
@export var actions: Array[UnitAction]


## Return all the actions this unit can take.[br]
func get_actions():
	pass


## Returns all actions that can be executed based on available AP and AP cost.
func get_available_actions():
	pass


func hurt():
	died.emit()


func execute_action(_action: UnitAction):
	pass
