extends Node

var commander: Commander


func _ready() -> void:
	GlobalSignalBus.battle_started.connect(_on_battle_started)


func _on_battle_started(battle: Battle):
	var commanders: Array[Commander]
	var commanders_arr = battle.teams.map(func(team: Team): return team.commander)
	commanders.append_array(commanders_arr)
	commander = Commander.get_first_human_commander(commanders)
