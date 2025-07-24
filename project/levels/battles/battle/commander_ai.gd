## AI-controlled [Commander] that makes tactical decisions for melee units in battle. [br]
## Implements specific tactical behaviors for controlling a single melee unit with move and attack capabilities. [br]
## Uses helper functions to evaluate the battlefield and make optimal decisions based on proximity to enemies.
class_name CommanderAI
extends Commander

class UnitActionPlan:
	var unit: Unit
	var actions: Array[UnitAction]


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
	# For each unit that can act:
		# take actions for the unit.
	end_turn.call_deferred()
	print.call_deferred("done")


func get_first_unit_that_can_act(units: Array[Unit]) -> Unit:
	pass


func move_to_melee_and_attack(unit: Unit):
	pass
	# Find the closest enemy unit
	# Move to it, closest available tile
	# Attack it


func take_actions_for_unit(unit: Unit):
	pass
	# make a unit action plan. UnitActionPlan
	# Based on what the unit can do and afford.
	# Create an action plan that will do the most damage.