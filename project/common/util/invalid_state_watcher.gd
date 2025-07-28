## Utility to watch over the game state and error if any unexpected states are identified
## Only meant to run during development, and will not run in release builds
extends Node

const MAX_COMMAND_RUN_TIME: int = 10

var running_command: ActionExecutionCommand
var time_since_command_started: float

func _ready():
	if not OS.has_feature("editor"):
		queue_free()
		return

	GlobalSignalBus.command_started.connect(_on_command_started)
	GlobalSignalBus.command_completed.connect(_on_command_completed)


func _on_command_started(command: ActionExecutionCommand):
	assert(
		running_command == null,
		"A different command was already running! Was the callback waited for?"
	)
	running_command = command


func _on_command_completed(command: ActionExecutionCommand):
	assert(
		running_command,
		"Unexpected call to command_completed when no command was running"
	)
	assert(
		running_command == command,
		"A different command was already running! Was the callback waited for?"
	)
	running_command = null
	time_since_command_started = 0


func _process(delta: float):
	if running_command:
		time_since_command_started += delta
		assert(
			time_since_command_started < MAX_COMMAND_RUN_TIME,
			"Command has been running for over %d seconds. Was the callback called?" % MAX_COMMAND_RUN_TIME
		)
