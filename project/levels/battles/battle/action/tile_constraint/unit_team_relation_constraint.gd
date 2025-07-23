class_name UnitTeamRelationConstraint
extends TargetTileConstraint

@export var team_relation: Team.Relationship


func _init(team_relation: Team.Relationship = Team.Relationship.ENEMY_TEAM) -> void:
	self.team_relation = team_relation


## The team relation that the target unit must have with the unit performing the action. [br]
func validate(
	command: ActionExecutionCommand,
	preview: ActionPreviewData,
):
	var target_units = command.targets.map(func(cell: BattleGridCell) -> Unit: return cell.unit)
	for target_unit in target_units:
		if (
			target_unit
			and target_unit.team
			and target_unit.team.has_relationship(command.unit.team, team_relation)
		):
			return true

	preview.add_error(get_error_message(team_relation))


func get_error_message(relationship: Team.Relationship):
	match relationship:
		Team.Relationship.SAME_TEAM:
			return tr("not_same_team")
		Team.Relationship.ALLY_TEAM:
			return tr("not_ally_team")
		Team.Relationship.NEUTRAL_TEAM:
			return tr("not_neutral_team")
		Team.Relationship.ENEMY_TEAM:
			return tr("not_enemy_team")
