extends CheckBox

var setting_path: String
var value_on


# Called when the node enters the scene tree for the first time.
func _ready():
	toggled.connect(_on_checkbox_toggled)


func _process(delta):
	pass


func _on_checkbox_toggled(button_pressed: bool):
	var value_on = self.value_on
	var setting_path = self.setting_path

	if button_pressed:
		ProjectSettings.set_setting(setting_path, value_on)
	else:
		ProjectSettings.clear(setting_path)
		#if typeof(value_on) == TYPE_BOOL:
		#ProjectSettings.set_setting(setting_path, !value_on)
		#elif setting_path == "rendering/quality/2d/texture_filter":
		#ProjectSettings.set_setting(setting_path, "linear")  # Default to linear when not nearest
		#else:
		#ProjectSettings.set_setting(setting_path, "")
	ProjectSettings.save()
	return
	# Set to default or opposite values based on the type of setting
