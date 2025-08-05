class_name Movement
extends Resource

enum Method {WALK, FLY, JUMP}
enum Type {
	## Use the assigned movement method to move
	SELF_DIRECTED,
	## Pushed by some external force
	PUSHED,
	## Teleported to a new location
	TELEPORTED,
}

@export var movement_points_per_ap: int = 2
@export var method: Method = Method.WALK

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
func get_ap_required_to_move(tiles_to_move: int) -> int:
	var move_count_short: int = tiles_to_move - _movement_points
	# print("currently have ", _movement_points, " movement points to move ", tiles_to_move, " tiles")
	if move_count_short <= 0:
		return 0
	# print("short ", move_count_short, " movement points")
	var fractional_ap_required: float = float(move_count_short) / movement_points_per_ap
	# Round up to get actual AP needed
	var ap_required: int = int(ceil(fractional_ap_required))
	# print("Need ", ap_required, " more AP to cover the difference")
	return ap_required


## Try to get enough movement points to move [param tile_to_move] tiles
## movement points will be spent if its reachable with [param current_ap] remaining
## It is assumed that it has already been validated the unit can afford the move
## and that the required AP will be removed outside of this function
func purchase_movement(tiles_to_move: int) -> int:
	var required_ap = get_ap_required_to_move(tiles_to_move)

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
