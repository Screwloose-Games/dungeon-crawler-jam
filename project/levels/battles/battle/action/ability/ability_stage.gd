## Represents a single phase of execution within an [Ability] on the [Battlefield]. [br]
## Abilities execute through multiple stages in sequence with configurable timing between each. [br]
## Each stage contains [AbilityEffect] objects that can be logical or visual effects. [br]
## Stages allow complex abilities to unfold over time with multiple distinct phases.
class_name AbilityStage
extends Resource

signal complete

@export var name: String
@export_multiline var description: String

## The effects to apply during this stage of the ability
@export var effects: Array[AbilityEffect]

var duration: float:
	get:
		return effects.reduce(
			func(accum: float, effect: AbilityEffect): return max(accum, effect.get_duration()), 0
		)


## Executes all effects in this stage of the ability. [br]
## Effects are applied in sequence, each receiving the target tile and casting unit context. [br]
## [br]
## [param _command] The action execution order containing target and caster context
func apply(_command: ActionExecutionCommand):
	pass


func _init(name: String = "", description: String = "", effects: Array[AbilityEffect] = []) -> void:
	self.name = name
	self.description = description
	self.effects = effects
