## Base class for actions that can be performed by a [Unit] on a [Battlefield]. [br]
## Unit actions represent the various commands that a [Commander] can give to their [Unit], [br]
## such as movement, attacks, abilities, or using an [Item]. [br]
## Each [Action] has an associated cost that determines how many Action Points (AP) it requires to execute.
class_name UnitAction
extends Resource

@export var name: String

@export_multiline var description: String

## The base cost required to execute this action. [br]
## Used as part of the calculation for cost, [member cost].
@export var base_cost: int

## The final calculated Action Point cost to execute this action. [br]
var cost: int:
	get = get_cost


## Note: Will be Overridden later by any @export values set.
func _init(_name: String = "", _description: String = "", _base_cost: int = 0) -> void:
	name = _name
	description = _description
	base_cost = _base_cost


## Calculates and returns the final cost for executing this action. [br]
## Override this method in derived classes to implement custom cost calculation logic [br]
## [br]
## [b]Returns:[/b] The calculated cost as an integer.
func get_cost() -> int:
	return base_cost


func get_constraints() -> Array[TargetTileConstraint]:
	## Returns an empty array by default, override in derived classes to provide specific constraints
	return []


func preview(_command: ActionExecutionCommand) -> ActionPreviewData:
	return null


func execute(_command: ActionExecutionCommand, callback: Callable):
	callback.call()
	return null
