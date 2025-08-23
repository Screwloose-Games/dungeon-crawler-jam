## A temporary condition that can be on a [Unit].[br]
## For example, dazed, reduced damage, etc.
## An abstract class intended to be inherited by specific
class_name StatusEffect
extends Resource

@export var name: String
@export var icon: Texture2D = preload("res://common/images/square.png")
@export var description: String

## The number of turns this status effect lasts
## Can be set to a negative number to last indefinitely
@export var turn_duration: int

var affected_unit: Unit
var turns_remaining: int
## All signals connected to by this status effect
## all signals tracked by this object will be disconnected once [remove_from_unit] is called
var signal_tracker: SignalTracker = SignalTracker.new()

## Apply this status effect to a affected_unit
## [param affected_unit] the affected_unit to apply the status effect to
## [param command] the command that resulted in the effect (nullable)
func apply(unit: Unit, _command: ActionExecutionCommand = null):
	self.affected_unit = unit
	unit.add_status_effect(self)

	signal_tracker.add_signal(unit.died, _on_unit_died)
	signal_tracker.add_signal(unit.turn_started, _on_unit_turn_started)

	turns_remaining = turn_duration


func remove_from_unit():
	affected_unit.remove_status_effect(self)
	affected_unit = null
	signal_tracker.disconnect_all_signals()


func _on_unit_died():
	remove_from_unit()


func _on_unit_turn_started():
	_reduce_turns_remaining(1)


func _reduce_turns_remaining(reduction_amount: int):
	if turn_duration < 0:
		return
	turns_remaining -= reduction_amount
	if turns_remaining <= 0:
		remove_from_unit()
