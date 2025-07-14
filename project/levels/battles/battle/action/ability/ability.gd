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
