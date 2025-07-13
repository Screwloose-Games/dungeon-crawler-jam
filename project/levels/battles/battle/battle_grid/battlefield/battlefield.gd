class_name Battlefield
extends Resource


@export var scene: PackedScene


func get_tile_data() -> Dictionary[Vector2i, BattleGridCell.TileType]:
	var instance: BattlefieldNode = scene.instantiate()
	return instance.tile_data
