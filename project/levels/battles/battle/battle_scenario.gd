## Defines the complete setup and rules for a tactical [Battle] encounter. [br]
## Contains all the information needed to initialize a battle including teams, relationships, and victory conditions. [br]
@tool
class_name BattleScenario
extends Resource

## All teams participating in this battle scenario
@export var teams: Array[Team]
## How each team relates to every other team (ally, enemy, neutral, etc.)
@export var team_relationships: Array[TeamRelationshipRecord]
## Conditions that determine when and how the battle ends
@export var end_conditions: Array[BattleEndCondition]

## Where the battle takes place
@export var battlefield: Battlefield
@export var grid_object_layouts: Array[GridObjectLayout]
