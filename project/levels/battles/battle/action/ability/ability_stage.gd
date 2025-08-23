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
@export var does_process_reactions: bool

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
func execute(command: ActionExecutionCommand, reactions: Array[Callable]):
	# If this individual stage processes reactions, ignore passed reaction array and use a new array
	# Otherwise reactions will be appended to the passed array
	if does_process_reactions:
		reactions = []
	var wait_request = WaitRequest.no_callback

	for effect in effects:
		effect.apply(command, wait_request, reactions)

	if does_process_reactions:
		await process_reactions(reactions)

	await wait_request.wait_until_complete()


func get_additional_ap_cost(command: ActionExecutionCommand) -> int:
	var total: int = 0
	for effect in effects:
		total += effect.get_additional_ap_cost(command)
	return total


func process_reactions(reactions: Array[Callable]):
	print("ability stage processing %d reactions" % len(reactions))
	var wait_request = WaitRequest.no_callback

	for reaction in reactions:
		reaction.call(wait_request)

	wait_request.all_participants_registered()
	await wait_request.wait_until_complete()
	print("all ability stage reactions processed")
