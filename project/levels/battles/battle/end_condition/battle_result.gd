class_name BattleResult
extends Resource

var winning_team: Team
var explanation_text: String

func _init(winning_team: Team, explanation_text: String) -> void:
	self.winning_team = winning_team
	self.explanation_text = explanation_text
