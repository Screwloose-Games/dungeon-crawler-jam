class_name Battlefield
extends Resource

enum TileType {
	GROUND,
	WALL,
	PIT,
}

@export var scene: PackedScene
# Where can a unit be placed?
# Where are walls,... etc?


func get_traversable_cells() -> Dictionary[Vector2i, TileType]:
	var traversable_cells: Dictionary[Vector2i, TileType] = {}
	return traversable_cells


func get_cells() -> Dictionary[Vector2i, TileType]:
	return {}


func test_get_grid() -> Array[Vector2i]:
	var instance: BattlefieldNode = scene.instantiate()
	return instance.cell_data
