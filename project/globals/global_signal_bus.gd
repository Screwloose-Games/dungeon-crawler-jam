extends Node

# Signals for unit-related events
signal unit_selected(unit: Unit, commander: Commander)
signal unit_health_changed(unit: Unit, new_health: float)
signal unit_hurt(unit: Unit, amount: float)
signal unit_healed(unit: Unit, amount: float)
signal unit_died(unit: Unit)
signal commander_turn_started(commander: Commander)

signal battle_grid_cell_selected(battle_grid_cel: BattleGridCell, commander: Commander)

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
signal battle_started
signal end_battle_requirements_met
signal level_reset
