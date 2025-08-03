class_name OverworldMapNode
extends TextureRect

@export var display_name: String
@export var scene_to_load: PackedScene
@export var connected_nodes: Array[OverworldMapNode]
@export var scene_root: Node2D


func load_scene():
	if not scene_to_load or not scene_to_load.can_instantiate():
		return
	get_tree().change_scene_to_packed(scene_to_load)


func _input(event: InputEvent):
	if event is not InputEventMouseButton:
		return
	var button_event = event as InputEventMouseButton
	if button_event.button_index == MOUSE_BUTTON_LEFT:
		accept_event()
		load_scene()
