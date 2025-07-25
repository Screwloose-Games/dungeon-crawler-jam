class_name ActionPreviewData
extends RefCounted

# visual elements
var highlighted_cells: Array[BattleGridCell]
var selected_cells: Array[BattleGridCell]
var path_tiles: Dictionary[Vector2i, MovementPath.Orientation]

# stat updates
var action_point_cost: int
var expected_damage: Dictionary[Unit, int]

# validity
var valid: bool:
	get:
		return len(_errors) == 0

var _errors: Array[String] = []


func _init(
	highlighted_cells: Array[BattleGridCell] = [],
	selected_cells: Array[BattleGridCell] = [],
	path_tiles: Dictionary[Vector2i, MovementPath.Orientation] = {},
	action_point_cost: int = 0,
	expected_damage: Dictionary[Unit, int] = {},
):
	self.highlighted_cells = highlighted_cells
	self.selected_cells = selected_cells
	self.path_tiles = {}
	self.action_point_cost = action_point_cost
	self.expected_damage = expected_damage


func add_error(reason: String):
	assert(reason != null and reason != "", "Reason should not be null or blank")
	_errors.append(reason)


func get_error_reasons() -> Array[String]:
	assert(len(_errors) > 0, "There are no _errors recorded")
	return _errors


func add_movement_path(path: MovementPath) -> void:
	path_tiles = path.get_path_orientations()
