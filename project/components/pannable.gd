## Add as the child of a [Camera2D] to make the camera pannable by
## using the middle mouse button.

class_name Pannable
extends Node

@export var pan_sensitivity: float = 1.0

## The camera node this component is attached to
var camera: Camera2D

var is_panning: bool = false

var last_mouse_position: Vector2


func _ready() -> void:
	camera = get_parent() as Camera2D
	if not camera:
		push_error("Pannable component must be a child of a Camera2D node")
		return


func _input(event: InputEvent) -> void:
	if not camera:
		return

	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_MIDDLE:
			if mouse_event.pressed:
				# Start panning
				is_panning = true
				last_mouse_position = mouse_event.global_position
			else:
				# Stop panning
				is_panning = false

	elif event is InputEventMouseMotion and is_panning:
		var mouse_event = event as InputEventMouseMotion
		var delta = (
			(last_mouse_position - mouse_event.global_position) * pan_sensitivity / camera.zoom
		)
		camera.global_position += delta
		last_mouse_position = mouse_event.global_position
