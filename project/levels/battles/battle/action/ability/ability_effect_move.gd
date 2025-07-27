## An [AbilityEffect] that moves a [Unit] to a target position on the [Grid]. [br]
## Used for teleportation, forced movement, or repositioning abilities. [br]
## Can be combined with [TargetTileConstraint] to ensure valid movement destinations.
class_name AbilityMoveEffect
extends AbilityEffect

## The animation duration for the movement effect in seconds
@export var movement_duration: float = 0.5

## Whether to animate the movement or instantly teleport
@export var instant_movement: bool = false


func _init(_movement_duration: float = 0.5, _instant: bool = false) -> void:
	self.movement_duration = _movement_duration
	self.instant_movement = _instant


## Moves the unit from the acting unit's position to the target cell. [br]
## If no unit is present on the acting cell, the effect does nothing. [br]
func apply(order: ActionExecutionCommand, _return_signal: ReturnSignal):
	if not order or not order.unit or order.targets.is_empty():
		return

	var target_cell = order.targets[0]
	if not target_cell:
		return

	var unit_to_move = order.unit

	if not _is_valid_movement_destination(unit_to_move, target_cell):
		return

	_move_unit_to_cell(unit_to_move, target_cell)


## Checks if the target cell is a valid movement destination
func _is_valid_movement_destination(unit: Unit, target_cell: BattleGridCell) -> bool:
	if not unit or not target_cell:
		return false

	if target_cell.unit and target_cell.unit != unit:
		return false

	if unit.movement:
		pass

	return true


func _move_unit_to_cell(unit: Unit, target_cell: BattleGridCell):
	unit.move_to_cell(target_cell)


func get_duration() -> float:
	return movement_duration if not instant_movement else 0.0
