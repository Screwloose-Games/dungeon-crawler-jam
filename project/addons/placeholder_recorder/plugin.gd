@tool
extends EditorPlugin

var scene_to_load = preload("res://addons/placeholder_recorder/PlaceholderRecorder.tscn")
var panel


func _enter_tree():
	var scene = scene_to_load.instantiate()
	panel = VBoxContainer.new()
	panel.name = "Placeholder Audio Recorder"
	panel.add_child(scene)
	add_control_to_bottom_panel(panel, panel.name)


func _exit_tree():
	remove_control_from_bottom_panel(panel)
	#remove_control_from_container(CONTAINER_TOOLBAR, panel)
	panel.queue_free()
