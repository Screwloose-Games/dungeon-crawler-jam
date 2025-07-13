class_name Ability
extends Resource

@export var name: String
@export var description: String
@export var number_of_targets: int
@export var constraints: Array[TileConstraint]
@export var stages: Array[AbilityStage]
