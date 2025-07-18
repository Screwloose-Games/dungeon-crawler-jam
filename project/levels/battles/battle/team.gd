## Represents a group of allied [Unit] units controlled by a single [Commander]. [br]
## Teams define relationships between different groups. [br]
## Used to determine targeting rules, alliance behavior, and victory conditions in [Battle]. [br]
## Each team has a [Commander] who makes tactical decisions for all units in the group.
## NOTE: @experimental We may allow multiple commanders per team in the future.
class_name Team
extends Resource

enum Relationship {
	SAME_TEAM,
	ALLY_TEAM,
	NEUTRAL_TEAM,
	ENEMY_TEAM,
}

## The commander who controls and makes decisions for this team.
@export var commander: Commander
## Display name for this team. This should be unique across all teams in a battle.
@export var name: String

var relationships: Dictionary[Team, Relationship] = {}
var units: Array[Unit]

static func set_team_relationship(team_a: Team, team_b: Team, relationship: Relationship) -> void:
	if not team_a or not team_b:
		push_error("Cannot set relationship with null team")
		return
	team_a._set_relationship(team_b, relationship)
	team_b._set_relationship(team_a, relationship)


static func unset_team_relationship(team_a: Team, team_b: Team, relationship: Relationship) -> void:
	if not team_a or not team_b:
		push_error("Cannot set relationship with null team")
		return
	team_a._unset_relationship(team_b, relationship)
	team_b._unset_relationship(team_a, relationship)


## Note: values will be overridden later by any @exported properties.
func _init(_name: String = "", _commander: Commander = null) -> void:
	self.name = _name
	self.commander = _commander
	GlobalSignalBus.unit_added_to_team.connect(_on_unit_added_to_team)
	GlobalSignalBus.unit_removed_from_team.connect(_on_unit_removed_from_team)


func _on_unit_added_to_team(unit: Unit, team: Team):
	if team != self:
		return
	assert(units.find(unit) < 0, "Unit %s already exists in team %s" % [unit.name, name])
	units.append(unit)


func _on_unit_removed_from_team(unit: Unit, team: Team):
	if team != self:
		return
	assert(units.find(unit) >= 0, "Unit %s does not exist in team %s" % [unit.name, name])
	units.erase(unit)


func is_on_same_team(other_team: Team) -> bool:
	return other_team == self


func _set_relationship(other_team: Team, relationship: Relationship) -> void:
	if not other_team:
		push_error("Cannot set relationship with null team")
		return
	if not self.relationships.has(other_team):
		self.relationships[other_team] = relationship
	else:
		self.relationships[other_team] = relationship


func _unset_relationship(other_team: Team, relationship: Relationship) -> void:
	if not other_team:
		push_error("Cannot unset relationship with null team")
		return
	if self.relationships.has(other_team):
		if self.relationships[other_team] == relationship:
			self.relationships.erase(other_team)


func get_relationship(other_team: Team) -> Relationship:
	if not other_team:
		push_error("Cannot get relationship with null team")
		return Relationship.NEUTRAL_TEAM
	if self.relationships.has(other_team):
		return self.relationships[other_team]
	return Relationship.NEUTRAL_TEAM


func has_relationship(other_team: Team, relationship: Relationship) -> bool:
	return self.get_relationship(other_team) == relationship
