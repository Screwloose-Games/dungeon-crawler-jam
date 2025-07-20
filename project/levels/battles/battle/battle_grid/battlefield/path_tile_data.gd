class_name PathTileData
extends RefCounted


## Points to the respective TileData for each path orientation
static var orientation_lookup: Dictionary[MovementPath.Orientation, PathTileData] = {
	MovementPath.Orientation.TOP_LEFT_BOTTOM_RIGHT: PathTileData.new(Vector2i(2, 1)),
	MovementPath.Orientation.TOP_RIGHT_BOTTOM_LEFT: PathTileData.new(Vector2i(2, 1), 1),

	MovementPath.Orientation.TOP_LEFT_BOTTOM_LEFT: PathTileData.new(Vector2i(3, 1)),
	MovementPath.Orientation.TOP_RIGHT_BOTTOM_RIGHT: PathTileData.new(Vector2i(3, 1), 1),

	MovementPath.Orientation.TOP_LEFT_TOP_RIGHT: PathTileData.new(Vector2i(0, 2)),
	MovementPath.Orientation.BOTTOM_LEFT_BOTTOM_RIGHT: PathTileData.new(Vector2i(0, 2), 1),

	MovementPath.Orientation.CENTER_BOTTOM_LEFT: PathTileData.new(Vector2i(1, 2)),
	MovementPath.Orientation.CENTER_BOTTOM_RIGHT: PathTileData.new(Vector2i(1, 2), 1),

	MovementPath.Orientation.CENTER_TOP_LEFT: PathTileData.new(Vector2i(2, 2)),
	MovementPath.Orientation.CENTER_TOP_RIGHT: PathTileData.new(Vector2i(2, 2), 1),

	MovementPath.Orientation.CENTER_DOT: PathTileData.new(Vector2i(3, 2)),
}

var atlas_position: Vector2i
var alternate_tile: int
var atlas_source: int

func _init(
	atlas_position: Vector2i = Vector2i.ZERO,
	alternate_tile: int = 0,
	atlas_source: int = 0,
):
	self.atlas_position = atlas_position
	self.alternate_tile = alternate_tile
	self.atlas_source = atlas_source
