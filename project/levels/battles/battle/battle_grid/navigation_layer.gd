class_name NavigationLayer
extends AStar2D

var cells: Dictionary[Vector2i, BattleGridCell]
var cell_ids: Dictionary[Vector2i, int]
var id_to_cell: Dictionary[int, BattleGridCell]


func _init(
	full_grid_cells: Dictionary[Vector2i, BattleGridCell],
	allowed_types: Array[BattleGridCell.TileType]
):
	cells = {}
	cell_ids = {}
	id_to_cell = {}
	for cell_position in full_grid_cells.keys():
		var cell := full_grid_cells[cell_position]
		if allowed_types.has(cell.type):
			var id = _position_id(cell_position)
			add_point(id, cell_position)
			cells[cell_position] = cell
			id_to_cell[id] = cell

	_create_connections()


func get_movement_path(from: Vector2i, to: Vector2i) -> MovementPath:
	if not cell_ids.has(from) or not cell_ids.has(to):
		return null # Unable to path

	var from_id = cell_ids[from]
	var to_id = cell_ids[to]

	# We should not be able to move onto occupied cells
	# ignore the cell we are currently on so it can be part of the path
	var occupied_cells = _get_occupied_cells(from)
	_set_points_disabled(true, occupied_cells)

	var id_path = get_id_path(from_id, to_id)

	# Re-enable occupied cells now that we have the path
	_set_points_disabled(false, occupied_cells)

	if not id_path:
		return null # Unable to path

	var movement_path = MovementPath.new()
	for id in id_path:
		var cell = id_to_cell[id]
		movement_path.cell_path.append(cell)
	return movement_path


func _get_occupied_cells(ignore_cell: Vector2i) -> Array[int]:
	var points_to_disable: Array[int] = []

	for cell_id in id_to_cell.keys():
		var cell = id_to_cell[cell_id]
		if not cell.unit or cell.position == ignore_cell:
			continue
		points_to_disable.append(cell_id)
	return points_to_disable


func _set_points_disabled(disabled: bool, cell_ids: Array[int]):
	for cell_id in cell_ids:
		set_point_disabled(cell_id, disabled)


func _create_connections():
	const NEIGHBORS: Array[Vector2i] = [
		Vector2i(-1, 0),
		Vector2i(1, 0),
		Vector2i(0, -1),
		Vector2i(0, 1)
	]

	for cell_position in cell_ids.keys():
		for neighbor_offset in NEIGHBORS:
			var neighbor_position: Vector2i = cell_position + neighbor_offset
			if not cell_ids.has(neighbor_position):
				continue
			_connect_cells(cell_position, neighbor_position)


func _connect_cells(position_a: Vector2i, position_b: Vector2i):
	var id_a = _position_id(position_a)
	var id_b = _position_id(position_b)
	if not are_points_connected(id_a, id_b):
		connect_points(id_a, id_b)


func _position_id(position: Vector2i) -> int:
	if not cell_ids.has(position):
		cell_ids[position] = get_available_point_id()
	return cell_ids[position]
