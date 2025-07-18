class_name LastStandingEndCondition
extends BattleEndCondition


func check_condition(battle: Battle) -> BattleResult:
	var winning_teams = battle.teams.duplicate()

	for team in battle.teams:
		if len(team.units) == 0:
			winning_teams.erase(team)

	if len(winning_teams) == 0:
		return BattleResult.new(null, "No teams remaining")
	if len(winning_teams) == 1:
		var winning_team = winning_teams[0]
		return BattleResult.new(winning_team, "%s won!" % winning_team.name)

	return null
