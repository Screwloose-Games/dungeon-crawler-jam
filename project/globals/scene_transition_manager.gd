extends Node

signal on_scene_changed
signal faded_out
signal faded_in


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS


func change_position(source: Node3D, target: Node3D):
	source.global_position = target.global_position


func change_position_with_transition(source: Node3D, target: Node3D, transition: PackedScene):
	var transition_instance: Transition = transition.instantiate()

	transition_instance.on_fade_out.connect(
		_on_fade_out_position.bind(source, target, transition_instance)
	)
	transition_instance.on_fade_in.connect(_on_fade_in.bind(transition_instance))
	add_child(transition_instance)


func change_scene(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)
	get_tree().tree_changed.connect(trigger_scene_changed_signal)


func change_scene_with_transition(scene: PackedScene, transition: PackedScene):
	var transition_instance: Transition = transition.instantiate()

	transition_instance.on_fade_out.connect(_on_fade_out.bind(scene, transition_instance))
	transition_instance.on_fade_in.connect(_on_fade_in.bind(transition_instance))

	add_child(transition_instance)


func _on_fade_out(new_scene: PackedScene, transition_instance: Transition):
	faded_out.emit()
	change_scene(new_scene)
	transition_instance.fade_in()


func _on_fade_in(transition_instance: Transition):
	faded_in.emit()
	transition_instance.queue_free()


func _on_fade_out_position(source: Node3D, target: Node3D, transition_instance: Transition):
	faded_out.emit()
	change_position(source, target)

	if source.has_node("Camera3D"):
		pass
		#var camera = source.get_node("Camera3D")
		#var cams = PhantomCameraManager.get_phantom_camera_3ds()
		#var camera = cams[0]
		#camera.follow_damping = false
		#camera.global_position = source.global_position
		#await get_tree().process_frame
		#camera.follow_damping = true
	transition_instance.fade_in()


func trigger_scene_changed_signal():
	on_scene_changed.emit()
	get_tree().tree_changed.disconnect(trigger_scene_changed_signal)
