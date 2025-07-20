class_name BattleRound
extends Resource

var turn_order: Array[Team]
var round_index: int
var turn_index: int
var current_turn_team: Team


func _init(team_turn_order: Array[Team]):
	self.turn_order = team_turn_order
	GlobalSignalBus.team_ended_turn.connect(_on_team_ended_turn)
	GlobalSignalBus.battle_started.connect(_on_battle_started)


func _on_battle_started(_battle: Battle):
	turn_index = 0
	round_index = 0
	_next_turn()


func _next_turn():
	# Move to next round
	if turn_index == len(turn_order):
		turn_index = 0
		round_index += 1
		GlobalSignalBus.battle_round_ended.emit()

	if turn_index == 0:
		GlobalSignalBus.battle_round_started.emit()

	current_turn_team = turn_order[turn_index]
	turn_index += 1
	begin_turn(current_turn_team)


func begin_turn(team: Team):
	GlobalSignalBus.battle_turn_started.emit(team)


func _on_team_ended_turn(team: Team):
	assert(team == current_turn_team, "Team '%s' requested to end turn, but it was not their turn!")
	GlobalSignalBus.battle_turn_ended.emit(team)
	_next_turn()
