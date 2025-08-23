class_name AddStatusAbilityEffect
extends AbilityEffect

@export var status_effect: StatusEffect


func apply(
	command: ActionExecutionCommand,
	_wait_request: WaitRequest,
	_reactions: Array[Callable]
):
	for target in command.targets:
		if target.unit:
			print("applying status effect to %s" % target.unit)
			var status_effect_instance = status_effect.duplicate()
			status_effect_instance.apply(target.unit, command)
