class_name ActionPreviewData
extends RefCounted

# visual elements
var highlighted_cells: Dictionary[Vector2i, CellHighlight]
var path_tiles: Dictionary[Vector2i, MovementPath.Orientation]

# stat updates
var action_point_cost: int
var expected_damage: Dictionary[Unit, int]


func _init(
	action_point_cost: int = 0,
	highlighted_cells: Dictionary[Vector2i, CellHighlight] = {},
	expected_damage: Dictionary[Unit, int] = {},
	path_tiles: Dictionary[Vector2i, MovementPath.Orientation] = {},
):
	self.action_point_cost = action_point_cost
	self.highlighted_cells = highlighted_cells
	self.expected_damage = expected_damage
	self.path_tiles = path_tiles


## Combine the two previews with [param overlay] overwriting tiles from [param base]
## Action points costs and expected damage will be added together
static func merge(base: ActionPreviewData, overlay: ActionPreviewData) -> ActionPreviewData:
	var action_point_cost = base.action_point_cost + overlay.action_point_cost
	var highlighted_cells = base.highlighted_cells.merged(overlay.highlighted_cells, true)
	var path_tiles = base.path_tiles.merged(overlay.path_tiles, true)

	var expected_damage = base.expected_damage
	for unit in overlay.expected_damage.keys():
		var overlay_damage = overlay.expected_damage[unit]
		if expected_damage.has(unit):
			expected_damage[unit] += overlay_damage
		else:
			expected_damage.set(unit, overlay_damage)

	return ActionPreviewData.new(action_point_cost, highlighted_cells, expected_damage, path_tiles)


func add_movement_path(path: MovementPath) -> void:
	path_tiles = path.get_path_orientations()
