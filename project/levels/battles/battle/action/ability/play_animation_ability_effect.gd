class_name PlayAnimationAbilityEffect
extends AbilityEffect

@export var wait_for_completion: bool
@export var animation_name: String

func apply(
	command: ActionExecutionCommand,
	wait_request: WaitRequest,
	_reactions: Array[Callable]
):
	var wait = wait_request if wait_for_completion else null
	command.unit.play_animation(animation_name, wait)
