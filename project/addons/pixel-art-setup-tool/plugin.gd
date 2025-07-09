@tool
extends EditorPlugin

var scene_to_load = preload("res://addons/pixel-art-setup-tool/my-scene.tscn")  # Update path to your scene file

var plugin_name = "Pixel Art Game Resolution and Rendering Settings"
var toolbar_text = "Pixel Art Settings"
var plugin_version = "1.0"

var control
var dropdown
var panel
var mode_checkbox
var aspect_checkbox
var snap_checkbox
var filter_checkbox
var mipmap_checkbox
var setting_checkbox = preload("res://addons/pixel-art-setup-tool/SettingCheckbox.gd")


func _enter_tree():
	dropdown = OptionButton.new()
	dropdown.add_item("320x180", 0)
	dropdown.add_item("384x216", 1)
	dropdown.add_item("426x240", 2)
	dropdown.add_item("640x360", 3)
	dropdown.connect("item_selected", _on_resolution_selected)

	panel = VBoxContainer.new()
	panel.name = "Resolution and settings Selector"
	panel.add_child(dropdown)

	mode_checkbox = add_checkbox(
		"Stretch Mode: Viewport", "display/window/stretch/mode", "viewport"
	)
	aspect_checkbox = add_checkbox("Aspect Ratio: Keep", "display/window/stretch/aspect", "keep")
	snap_checkbox = add_checkbox(
		"Pixel Snap Transforms", "rendering/2d/snap/snap_2d_transforms_to_pixel", true
	)
	add_checkbox("Pixel Snap Vertices", "rendering/2d/snap/snap_2d_vertices_to_pixel", true)
	add_checkbox(
		"Texture filter pixel perfect (nearest)",
		"rendering/textures/canvas_textures/default_texture_filter",
		0
	)
	add_checkbox("Force PNG", "textures/lossless_compression/force_png", 0)
	var scene = scene_to_load.instantiate()
	panel.add_child(scene)

	## Create a new button
	#var button = Button.new()
	#button.text = "Pixel Art Settings"
	## Connect the button's pressed signal to a custom function
	#button.pressed.connect(_on_button_pressed)
	# Add the button to the top toolbar
	#add_control_to_container(CONTAINER_TOOLBAR, button)

	add_control_to_bottom_panel(panel, toolbar_text)
	#add_control_to_container(CONTAINER_TOOLBAR, panel)
	#get_editor_interface().get_editor_main_screen().add_child(panel)
	#editor = EditorScene.instantiate()

	# add editor to main viewport
	#get_editor_interface().get_editor_main_screen().add_child(panel)


func _on_button_pressed():
	pass


func _exit_tree():
	remove_control_from_bottom_panel(panel)
	remove_control_from_container(CONTAINER_TOOLBAR, panel)
	panel.queue_free()


func _on_resolution_selected(index):
	const WIDTH_SETTING = "display/window/size/viewport_width"
	const HEIGHT_SETTING = "display/window/size/viewport_height"
	match index:
		0:
			ProjectSettings.set_setting(WIDTH_SETTING, 320)
			ProjectSettings.set_setting(HEIGHT_SETTING, 180)
		1:
			ProjectSettings.set_setting(WIDTH_SETTING, 384)
			ProjectSettings.set_setting(HEIGHT_SETTING, 216)
		2:
			ProjectSettings.set_setting(WIDTH_SETTING, 426)
			ProjectSettings.set_setting(HEIGHT_SETTING, 240)
		3:
			ProjectSettings.set_setting(WIDTH_SETTING, 640)
			ProjectSettings.set_setting(HEIGHT_SETTING, 360)
	ProjectSettings.save()


func add_checkbox(text, setting_path, value_on):
	var checkbox = setting_checkbox.new()
	checkbox.text = text
	var is_set = ProjectSettings.get_setting(setting_path) == value_on
	checkbox.set_pressed_no_signal(is_set)
	checkbox.setting_path = setting_path
	checkbox.value_on = value_on
	panel.add_child(checkbox)
	return checkbox


func _on_checkbox_toggled(button_pressed: bool):
	var value_on = self.value_on
	var setting_path = self.setting_path

	if button_pressed:
		ProjectSettings.set_setting(setting_path, value_on)
	else:
		ProjectSettings.clear(setting_path)
	ProjectSettings.save()


func _get_plugin_name():
	return plugin_name


func _get_plugin_version():
	return plugin_version
