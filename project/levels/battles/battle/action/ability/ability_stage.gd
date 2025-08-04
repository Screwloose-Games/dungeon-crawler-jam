## Represents a single phase of execution within an [Ability] on the [Battlefield]. [br]
## Abilities execute through multiple stages in sequence with configurable timing between each. [br]
## Each stage contains [AbilityEffect] objects that can be logical or visual effects. [br]
## Stages allow complex abilities to unfold over time with multiple distinct phases.
class_name AbilityStage
extends Resource

@export var name: String
@export_multiline var description: String

## The effects to apply during this stage of the ability
@export var effects: Array[AbilityEffect]

var duration: float:
	get:
		return effects.reduce(
			func(accum: float, effect: AbilityEffect): return max(accum, effect.get_duration()), 0
		)

var does_damage: bool:
	get = get_does_damage


func _init(name: String = "", description: String = "", effects: Array[AbilityEffect] = []) -> void:
	self.name = name
	self.description = description
	self.effects = effects


func preview(command: ActionExecutionCommand, preview: ActionPreviewData):
	for effect in effects:
		effect.preview(command, preview)


func get_does_damage():
	return effects.any(func(effect: AbilityEffect): return effect.does_damage)


## Executes all effects in this stage of the ability. [br]
## Effects are applied in sequence, each receiving the target tile and casting unit context. [br]
## [br]
## [param _command] The action execution order containing target and caster context
func execute(command: ActionExecutionCommand, return_signal: ReturnSignal):
	for effect in effects:
		effect.apply(command, return_signal)


func get_additional_ap_cost(command: ActionExecutionCommand) -> int:
	var total: int = 0
	for effect in effects:
		total += effect.get_additional_ap_cost(command)
	return total
