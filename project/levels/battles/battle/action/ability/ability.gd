## A special power or skill that can be executed by a [Unit] through an [AbilityAction]. [br]
## Can target single or multiple positions on the [Grid] based on [TargetTileConstraint]. [br]
## Executes through multiple stages [AbilityStage] to compose different effects.
class_name Ability
extends Resource

## Display name for this ability
@export var name: String
## Detailed description of what the ability does and how it works
@export_multiline var description: String
## How many individual targets can be selected for this ability
@export var number_of_targets: int
## Rules that determine which tiles can be targeted by this ability
@export var constraints: Array[TargetTileConstraint]
## Sequential phases of execution that define the ability's complete effect over time
@export var stages: Array[AbilityStage]
## The cost in Action Points (AP) to execute this ability
## This is the base cost before any modifications from effects or conditions
@export_range(0, 20, 1) var base_cost: int


func _init(
	name: String = "",
	description: String = "",
	number_of_targets: int = 1,
	constraints: Array[TargetTileConstraint] = [],
	stages: Array[AbilityStage] = [],
	base_cost: int = 0
) -> void:
	self.name = name
	self.description = description
	self.number_of_targets = number_of_targets
	self.constraints = constraints
	self.stages = stages
	self.base_cost = base_cost


func execute(command: ActionExecutionCommand, callback: Callable):
	var return_signal = ReturnSignal.new(callback)
	for stage in stages:
		stage.execute(command, return_signal)
	return_signal.all_participants_registered()