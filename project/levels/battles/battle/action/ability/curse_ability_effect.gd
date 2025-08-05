class_name CurseAbilityEffect
extends AbilityEffect


func apply(command: ActionExecutionCommand, _return_signal: ReturnSignal):
	for target in command.targets:
		if target.unit:
			target.unit.is_cursed = true
