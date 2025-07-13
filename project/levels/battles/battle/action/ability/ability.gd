## A special power or skill that can be executed by a [Unit] through an [AbilityAction]. [br]
## Can target single or multiple positions on the [Grid] based on [TileConstraint]. [br]
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
@export var constraints: Array[TileConstraint]
## Sequential phases of execution that define the ability's complete effect over time
@export var stages: Array[AbilityStage]
