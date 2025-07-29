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

	var id_path = get_id_path(from_id, to_id, true)

	# Re-enable occupied cells now that we have the path
	_set_points_disabled(false, occupied_cells)

	if not id_path:
		return null # Unable to path

	var movement_path = MovementPath.new()
	for id in id_path:
		var cell = id_to_cell[id]
		movement_path.cell_path.append(cell)
	return movement_path


func get_cells_within_distance(from_cell: BattleGridCell, distance: int) -> Array[BattleGridCell]:
	if not cell_ids.has(from_cell.position):
		return []

	# Performs flood-fill algorithm to find all connected cells within the given distance
	# cell IDs that we have already visited
	var visited: Dictionary[int, bool] = {}
	# Positions that we will visit next. X component is cell id, Y component is remaining distance left
	var to_visit_queue: Array[Vector2i] = []

	var start_cell_id = cell_ids[from_cell.position]
	to_visit_queue.append(Vector2i(start_cell_id, distance))


	while len(to_visit_queue) > 0:
		var next = to_visit_queue.pop_front()
		var cell_id = next.x
		var distance_left = next.y

		if visited.has(cell_id):
			continue

		visited[cell_id] = true

		if distance_left <= 0:
			continue

		var connections = get_point_connections(cell_id)
		for connected_id in connections:
			if not visited.has(connected_id):
				to_visit_queue.push_back(Vector2i(connected_id, distance_left - 1))

	return _ids_to_cells(visited.keys())


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


func _ids_to_cells(ids: Array[int]) -> Array[BattleGridCell]:
	var cells: Array[BattleGridCell] = []
	for id in ids:
		cells.append(id_to_cell[id])
	return cells
