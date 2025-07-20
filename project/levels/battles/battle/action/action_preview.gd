class_name ActionPreview
extends Resource

var highlighted_cells: Array[BattleGridCell]
var selected_cells: Array[BattleGridCell]
var action_point_cost: int
var expected_damage: Dictionary[Unit, int]
var path_tiles: Dictionary[Vector2i, int]


func _init(
	highlighted_cells: Array[BattleGridCell] = [],
	selected_cells: Array[BattleGridCell] = [],
	action_point_cost: int = 0,
	expected_damage: Dictionary[Unit, int] = {},
	path_tiles: Dictionary[Vector2i, MovementPath.Orientation] = {}
):
	self.highlighted_cells = highlighted_cells
	self.selected_cells = selected_cells
	self.action_point_cost = action_point_cost
	self.expected_damage = expected_damage
	self.path_tiles = {}


func set_path_tiles(path: MovementPath):
	return
