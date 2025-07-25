class_name Movement
extends Resource

enum MovementMethod { WALK, FLY, JUMP }

@export var movement_points_per_ap: int = 2
@export var method: MovementMethod = MovementMethod.WALK

var can_move: bool:
	get:
		return _has_movement_points

## The purchased, remaining movement points.
var _movement_points: int = 0

var _has_movement_points: bool:
	get:
		return _movement_points > 0


func max_move_count(current_ap: int) -> int:
	return current_ap * movement_points_per_ap + _movement_points


## Determine the number of AP required to move [param tiles_to_move] tiles
## Takes into account any purchased movement points
func get_required_ap_to_move(tiles_to_move: int) -> int:
	var move_count_short: int = tiles_to_move - _movement_points
	print("currently have ", _movement_points, " movement points to move ", tiles_to_move, " tiles")
	if move_count_short <= 0:
		return 0
	print("short ", move_count_short, " movement points")
	var fractional_ap_required: float = float(move_count_short) / movement_points_per_ap
	# Round up to get actual AP needed
	var ap_required: int = int(ceil(fractional_ap_required))
	print("Need ", ap_required, " more AP to cover the difference")
	return ap_required


## Try to get enough movement points to move [param tile_to_move] tiles
## movement points will be spent if its reachable with [param current_ap] remaining
## It is assumed that it has already been validated the unit can afford the move
## and that the required AP will be removed outside of this function
func purchase_movement(tiles_to_move: int) -> int:
	var required_ap = get_required_ap_to_move(tiles_to_move)

	# purchase movement points
	print(required_ap * movement_points_per_ap, " movement points purchased")
	_movement_points += required_ap * movement_points_per_ap

	# spend movement points
	print("spending ", tiles_to_move, " movement points")
	_movement_points -= tiles_to_move

	print(_movement_points, " movement points remaining")

	return required_ap


func reset_movement_points():
	_movement_points = 0


## Get all cells that this unit can move to given current action points and movement constraints
## Requires access to the unit's current position and the battle grid for pathfinding
func get_reachable_cells(unit: Unit, battle_grid: BattleGrid) -> Array[BattleGridCell]:
	if not unit or not unit.cell or not battle_grid:
		return []

	var reachable_cells: Array[BattleGridCell] = []
	var max_movement_distance = max_move_count(unit.action_points_current)

	if max_movement_distance <= 0:
		return []

	var start_position = unit.cell.position

	# Get the appropriate navigation layer based on movement method
	var navigation_layer: NavigationLayer
	match method:
		MovementMethod.WALK:
			navigation_layer = battle_grid.walk_navigation
		MovementMethod.FLY:
			navigation_layer = battle_grid.fly_navigation
		_:
			# Default to walk navigation if method not implemented
			navigation_layer = battle_grid.walk_navigation

	if not navigation_layer:
		return []

	# Check all cells in the battle grid
	for target_position in battle_grid.cells.keys():
		var target_cell = battle_grid.cells[target_position]

		# Skip the unit's current position
		if target_position == start_position:
			continue

		# Check if the cell is movable to
		if not battle_grid.is_cell_movable_to(target_position, method):
			continue

		# Get the movement path to this cell
		var path = navigation_layer.get_movement_path(start_position, target_position)

		# If we can path to this cell and it's within our movement range
		if path and path.move_count <= max_movement_distance:
			# Calculate the AP cost to reach this cell
			var required_ap = get_required_ap_to_move(path.move_count)

			# If we can afford to move there with current AP
			if required_ap <= unit.action_points_current:
				reachable_cells.append(target_cell)

	return reachable_cells
