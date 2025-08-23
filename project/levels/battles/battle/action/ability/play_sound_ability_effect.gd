class_name PlaySoundAbilityEffect
extends AbilityEffect

@export var audio: AudioStream

func apply(
	_command: ActionExecutionCommand,
	_wait_request: WaitRequest,
	_reactions: Array[Callable]
):
	SoundManager.play_sound(audio)