class_name TestHelper
extends Resource

static func get_grid_with_tiles(tile_positions: Array[Vector2i]) -> BattleGrid:
	var battlefield: Battlefield = Battlefield.new()
	battlefield.tile_data = {}

	for tile_pos in tile_positions:
		battlefield.tile_data.set(tile_pos, BattleGridCell.TileType.GROUND)

	return BattleGrid.new(battlefield)
