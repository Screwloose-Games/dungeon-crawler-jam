extends Node

# Signals for player-related events
signal player_health_changed(new_val: float)
signal player_hurt(amount: float)
signal player_healed(amount: float)
signal player_stepped(surface)  # Needs SurfaceType enum
signal player_jumped
signal player_died
signal player_started_moving
signal player_stopped_moving
signal player_started_idling
signal player_started_attack
signal player_stopped_attack
signal player_used_ability(ability)
signal player_leveled_up
signal player_progress_reset(current: int, min: int, max: int)
signal player_progress_updated(progress: int)

# Upgrades
signal player_upgraded_stat
signal player_spent_level_point

# levels / menus
signal changed_level
signal title_screen_started
signal credits_screen_started
signal level_started
signal game_paused
signal game_unpaused

# Signals for enemy-related events
signal enemy_died
signal enemy_hurt
signal enemy_targeted_player

signal coin_collected
signal coin_attracted

signal weapon_equipped(weapon_type)

# Signals for menu-related events
signal main_menu_started
signal start_level_requested(level_num: int)

signal win_game_requirements_met
signal level_reset
