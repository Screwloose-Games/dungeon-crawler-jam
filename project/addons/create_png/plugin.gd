@tool
extends EditorPlugin

var command_name: StringName = "Create Blank PNG"


func _enter_tree():
	# Get the file system dock
	var fs_dock = get_editor_interface().get_file_system_dock()

	# Add command to the Command Palette
	var command_palette = get_editor_interface().get_command_palette()
	command_palette.add_command(command_name, "File/Create", Callable(self, "_prompt_for_filename"))


#func _exit_tree():
## Remove menu item and command when the plugin is disabled
#var command_palette = get_editor_interface().get_command_palette()
#if command_palette
#command_palette.remove_command(command_name)


func _prompt_for_filename():
	var file_dialog = EditorFileDialog.new()
	file_dialog.file_mode = EditorFileDialog.FILE_MODE_SAVE_FILE
	file_dialog.access = EditorFileDialog.ACCESS_RESOURCES
	var current_dir = get_editor_interface().get_current_directory()
	var file_path = current_dir + "/placeholder_image.png"
	file_dialog.add_filter("*.png ; PNG Images")
	file_dialog.title = "Choose PNG file name"
	file_dialog.set_current_path(file_path)

	file_dialog.connect("file_selected", Callable(self, "_save_blank_png"))
	get_editor_interface().get_base_control().add_child(file_dialog)
	file_dialog.popup_centered()


func _save_blank_png(file_path: String):
	var img = Image.create_empty(32, 32, false, Image.FORMAT_RGBA8)
	img.fill(Color.WHITE)

	var error = img.save_png(file_path)
	if error == OK:
		_import_resource(file_path)
		print("Blank PNG created at:", file_path)
	else:
		print("Failed to create PNG file at:", file_path)


func _import_resource(file_path: String):
	# Request the filesystem to re-scan and import the newly created file
	get_editor_interface().get_resource_filesystem().scan()

	# Optional: Open the imported image in the editor
	var image_texture = load(file_path)
	get_editor_interface().edit_resource(image_texture)
