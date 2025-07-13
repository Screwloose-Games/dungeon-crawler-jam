class_name Battlefield
extends Resource

enum TileType {
	GROUND,
	WALL,
	PIT,
}

@export var scene: PackedScene


func get_tile_data_from_scene() -> Dictionary[Vector2i, TileType]:
	var instance: BattlefieldNode = scene.instantiate()
	return instance.tile_data
