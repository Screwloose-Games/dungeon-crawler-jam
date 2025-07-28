class_name TeamRelationshipRecord
extends Resource

@export var team_a: Team:
	set(val):
		team_a = val
		set_relationship()
@export var team_b: Team:
	set(val):
		team_b = val
		set_relationship()
@export var relationship: Team.Relationship:
	set(val):
		relationship = val
		set_relationship()


func set_relationship():
	if team_a and team_b and relationship:
		Team.set_team_relationship(team_a, team_b, relationship)
