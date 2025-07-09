extends Control

@onready var experience_current_level_bar: ProgressBar = %ExperienceCurrentLevelBar
@onready var level_up_button: Button = %LevelUpButton
@onready var upgrade_overlay: CanvasLayer = %UpgradeOverlay


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBus.player_spent_level_point.connect(_on_player_spent_level_point)
	GlobalSignalBus.player_leveled_up.connect(_on_player_leveled_up)
	GlobalSignalBus.player_progress_reset.connect(_on_player_progress_reset)
	GlobalSignalBus.player_progress_updated.connect(_on_player_progress_updated)
	level_up_button.pressed.connect(_on_level_up_button_pressed)
	upgrade_overlay.close_button.pressed.connect(_on_upgrade_close_button_pressed)
	_setup_xp_bar()


func _on_upgrade_close_button_pressed():
	get_tree().paused = false


func _setup_xp_bar():
	experience_current_level_bar.value = PlayerProgress.points_this_level
	experience_current_level_bar.max_value = PlayerProgress.get_points_until_next_level()


func _on_player_progress_reset(current: int, minimum: int, maximum: int):
	experience_current_level_bar.value = current
	experience_current_level_bar.min_value = minimum
	experience_current_level_bar.max_value = maximum


func _on_player_progress_updated(current: int):
	experience_current_level_bar.value = current


func _on_player_spent_level_point():
	if not PlayerProgress.has_unspent_points():
		level_up_button.hide()


func _on_player_leveled_up():
	reset_xp_bar()
	show_level_up_button()


func _on_level_up_button_pressed():
	open_level_up_screen()


func open_level_up_screen():
	get_tree().paused = true
	upgrade_overlay.show()


func reset_xp_bar():
	experience_current_level_bar.value = 0


func show_level_up_button():
	level_up_button.show()
