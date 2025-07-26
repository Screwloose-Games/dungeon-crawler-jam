class_name ActionPreviewData
extends RefCounted

# visual elements
var highlighted_cells: Dictionary[Vector2i, CellHighlight]
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
	action_point_cost: int = 0,
	highlighted_cells: Dictionary[Vector2i, CellHighlight] = {},
	expected_damage: Dictionary[Unit, int] = {},
	path_tiles: Dictionary[Vector2i, MovementPath.Orientation] = {},
):
	self.highlighted_cells = highlighted_cells
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


func clear():
	_init()
	_errors.clear()
