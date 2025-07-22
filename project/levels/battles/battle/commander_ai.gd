## AI-controlled [Commander] that makes tactical decisions for melee units in battle. [br]
## Implements specific tactical behaviors for controlling a single melee unit with move and attack capabilities. [br]
## Uses helper functions to evaluate the battlefield and make optimal decisions based on proximity to enemies.
class_name CommanderAI
extends Commander


func _init(
	name: String = "",
	description: String = "",
	_type: CommanderType = CommanderType.AI,
	team: Team = null
):
	super(name, description, CommanderType.AI, team)
	GlobalSignalBus.battle_turn_started.connect(_on_battle_turn_started)


func _on_battle_turn_started(team: Team):
	print("battle turn started")
	if team != self.team:
		return
	start_turn()


func start_turn():
	print("Starting AI turn")
	end_turn.call_deferred()
	print.call_deferred("done")
