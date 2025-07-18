extends CanvasLayer

var main_menu_scene: PackedScene = SceneManager.main_menu
var options_menu_scene: PackedScene = SceneManager.options_menu

@onready var continue_button = %ContinueButton
@onready var options_button = %OptionsButton
@onready var main_menu_button = %MainMenuButton
@onready var pause_menu_body = %PauseMenuBody
@onready var quit_button: Button = %QuitButton


func _ready():
	#get_tree().paused = true
	visible = false
	continue_button.pressed.connect(on_continue_pressed)
	main_menu_button.pressed.connect(on_main_menu_pressed)
	options_button.pressed.connect(on_options_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	if OS.has_feature("web"):
		quit_button.hide()


func _on_quit_button_pressed():
	get_tree().quit(0)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause()


func pause():
	var should_pause = !get_tree().paused
	get_tree().paused = should_pause
	visible = should_pause

	if should_pause:
		GlobalSignalBus.game_paused.emit()
	else:
		GlobalSignalBus.game_unpaused.emit()


func on_continue_pressed():
	get_tree().paused = false
	visible = false
	GlobalSignalBus.game_unpaused.emit()
	#queue_free()


func on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu_scene)


func on_options_pressed():
	var options_menu_instance = options_menu_scene.instantiate()
	options_menu_instance.back_pressed.connect(on_options_back_pressed.bind(options_menu_instance))
	pause_menu_body.visible = false
	add_child(options_menu_instance)


func on_options_back_pressed(options_menu: OptionsMenu):
	pause_menu_body.visible = true
	options_menu.queue_free()
