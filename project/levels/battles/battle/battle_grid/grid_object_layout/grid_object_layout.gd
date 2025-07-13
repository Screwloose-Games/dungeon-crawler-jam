class_name GridObjectLayout
extends Resource

@export var scene: PackedScene


func get_tile_data() -> Dictionary[Vector2i, ObjectLayoutCell]:
	var instance: GridObjectLayoutNode = scene.instantiate()
	return instance.tile_data
