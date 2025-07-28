class_name UnitTeamRelationConstraint
extends TargetTileConstraint

@export var team_relation: Team.Relationship


func _init(team_relation: Team.Relationship = Team.Relationship.ENEMY_TEAM) -> void:
	self.team_relation = team_relation


## The team relation that the target unit must have with the unit performing the action. [br]
func _validate_cell(command: ActionExecutionCommand, cell: BattleGridCell) -> bool:
	if not cell.unit:
		return false
	return cell.unit.team and cell.unit.team.has_relationship(command.unit.team, team_relation)
