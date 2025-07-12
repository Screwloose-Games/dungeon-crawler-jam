class_name GridObjectLayout
extends Resource

@export var scene: PackedScene


func get_tile_data_from_scene() -> Dictionary[Vector2i, GridObjectCell]:
	var instance: GridObjectLayoutNode = scene.instantiate()
	return instance.tile_data
