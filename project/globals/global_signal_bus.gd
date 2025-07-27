@tool
extends Node

# Signals for unit-related events
signal unit_selected(unit: Unit, commander: Commander)
signal unit_health_changed(unit: Unit, new_health: float)
signal unit_hurt(unit: Unit, amount: float)
signal unit_healed(unit: Unit, amount: float)
signal unit_died(unit: Unit)
signal commander_turn_started(commander: Commander)
signal unit_removed_from_team(unit: Unit, team: Team)
signal unit_added_to_team(unit: Unit, team: Team)

signal battle_grid_cell_selected(battle_grid_cel: BattleGridCell, commander: Commander)

# Team events
signal team_ended_turn(team: Team)

# levels / menus
signal changed_level
signal title_screen_started
signal credits_screen_started
signal level_started
signal game_paused
signal game_unpaused

# Signals for menu-related events
signal main_menu_started
signal start_level_requested(level_num: int)

# Battles
signal battle_started(battle: Battle)
signal battle_ended(result: BattleResult)
signal battle_round_started
signal battle_round_ended
signal battle_turn_started(team: Team)
signal battle_turn_ended(team: Team)
signal level_reset

# Player input
signal player_selected_unit(unit: Unit)
signal player_unselected_unit(unit: Unit)
signal player_selected_action(unit_action: UnitAction)
signal player_unselected_action(unit_action: UnitAction)

# Action previews/highlights
signal action_preview_requested(preview_data: ActionPreviewData)
signal action_preview_cancelled(preview_data: ActionPreviewData)


func _init() -> void:
	unit_removed_from_team.connect(_on_unit_removed_from_team)
	unit_added_to_team.connect(_on_unit_added_to_team)

	team_ended_turn.connect(_on_team_ended_turn)

	battle_started.connect(_on_battle_started)
	battle_ended.connect(_on_battle_ended)
	battle_round_started.connect(_on_battle_round_started)
	battle_round_ended.connect(_on_battle_round_ended)
	battle_turn_started.connect(_on_battle_turn_started)
	battle_turn_ended.connect(_on_battle_turn_ended)

	player_selected_unit.connect(_on_player_selected_unit)
	player_unselected_unit.connect(_on_player_unselected_unit)
	player_selected_action.connect(_on_player_selected_action)
	player_unselected_action.connect(_on_player_unselected_action)

	action_preview_requested.connect(_on_action_preview_requested)
	action_preview_cancelled.connect(_on_action_preview_cancelled)


func _on_unit_selected(unit: Unit, commander: Commander):
	print("unit_selected: %s %s" % [unit.name, commander.name])


func _on_unit_removed_from_team(unit: Unit, team: Team):
	print("unit_removed_from_team: %s %s" % [unit, team.name])


func _on_unit_added_to_team(unit: Unit, team: Team):
	print("unit_added_to_team: %s %s" % [unit.name, team.name])


func _on_team_ended_turn(team: Team):
	print("team_ended_turn: %s" % team.name)


func _on_battle_started(_battle: Battle):
	print("battle_started")


func _on_battle_ended(result: BattleResult):
	print("battle_ended: %s" % result.explanation_text)


func _on_battle_round_started():
	print("battle_round_started")


func _on_battle_round_ended():
	print("battle_round_ended")


func _on_battle_turn_started(team: Team):
	print("battle_turn_started: %s" % team.name)


func _on_battle_turn_ended(_team: Team):
	print("battle_turn_ended")


func _on_action_preview_requested(_preview_data: ActionPreviewData):
	pass
	#print("action_preview_requested")


func _on_action_preview_cancelled(_preview_data: ActionPreviewData):
	pass
	#print("action_preview_cancelled")


func _on_player_selected_unit(unit: Unit):
	print("player_selected_unit: %s" % unit.name)


func _on_player_unselected_unit(unit: Unit):
	print("player_unselected_unit: %s" % unit.name)


func _on_player_selected_action(action: UnitAction):
	print("player_selected_action: %s" % action.name)


func _on_player_unselected_action(action: UnitAction):
	print("player_unselected_action: %s" % action.name)
