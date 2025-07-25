class_name GridObjectLayout
extends Resource

@export var scene: PackedScene

@export var tile_data: Dictionary[Vector2i, ObjectLayoutCell]


func get_tile_data() -> Dictionary[Vector2i, ObjectLayoutCell]:
	return tile_data
	#var instance: GridObjectLayoutNode = scene.instantiate()
	#return instance.tile_data
