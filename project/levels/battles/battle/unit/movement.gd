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


## Try to get enough movement points to move [param move_count] tiles
## movement points will be spent if it reachable with [param current_ap] remaining
## The function returns the amount of AP needed to be spent to move, or -1 if the move is not possible
func try_move(move_count: int, current_ap: int) -> int:
	var move_count_short: float = move_count - _movement_points
	var ap_to_spend: int = 0

	if move_count_short > 0:
		# Must spend action points to get the remaining movement points
		ap_to_spend = int(ceil(move_count_short / movement_points_per_ap))
		if ap_to_spend > current_ap:
			return -1

		# AP -> movement points
		_movement_points += movement_points_per_ap * ap_to_spend

	# spend movement points
	_movement_points -= move_count

	return ap_to_spend