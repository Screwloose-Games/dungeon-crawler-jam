class_name MovementPath
extends Resource

## An Orientation describing how one segment of the path is related to its neighbors
## Orientations do not encode direction, meaning TOP_LEFT_TOP_RIGHT would also represent TOP_RIGHT_TOP_LEFT
enum Orientation
{
	CENTER_DOT,

	# Name in START_END format where START and END can be any of
	# CENTER, TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT

	# Center to edge
	CENTER_TOP_RIGHT,
	CENTER_TOP_LEFT,
	CENTER_BOTTOM_RIGHT,
	CENTER_BOTTOM_LEFT,

	# Straight line through cell
	TOP_RIGHT_BOTTOM_LEFT,
	TOP_LEFT_BOTTOM_RIGHT,

	# Turns
	BOTTOM_LEFT_BOTTOM_RIGHT,
	TOP_LEFT_TOP_RIGHT,
	TOP_LEFT_BOTTOM_LEFT,
	TOP_RIGHT_BOTTOM_RIGHT
}

const TOP_LEFT = Vector2i(-1, 0)
const TOP_RIGHT = Vector2i(0, -1)
const BOTTOM_LEFT = Vector2i(0, 1)
const BOTTOM_RIGHT = Vector2i(1, 0)

var cell_path: Array[BattleGridCell]

func _init(cell_path: Array[BattleGridCell] = []):
	self.cell_path = cell_path


## Convert the path into a list of path orientations,
## that describe the relations between each part of the path
func get_path_orientations() -> Array[Orientation]:
	if not cell_path or len(cell_path) == 0:
		return []

	var orientations: Array[Orientation]

	for i in len(cell_path):
		var current = cell_path[i]
		var from = null
		var next = null

		if i > 1:
			from = cell_path[i - 1]
		if i < len(cell_path) - 1:
			next = cell_path[i + 1]

		orientations.append(MovementPath.get_orientation(from, current, next))
	return orientations


## Get the path orientation needed to describe the current path
##  [param from] is the previous cell in the path, may be null,
##  [param current] is the current cell being evaluated in the path, may not be null
##  [param next] is the cell to be moved to next in path, may be null
## It is assumed that the TileMapLayer is using diamond down
##  meaning that +X axis is bottom-right, and +Y axis is bottom-left
static func get_orientation(from: Vector2i, current: Vector2i, next: Vector2i) -> MovementPath.Orientation:
	assert(current, "Invalid parameter. current may not be null")

	# No path = CENTER_DOT
	if not from and not next:
		return Orientation.CENTER_DOT

	# If path start or end, determine direction from center
	if not from or not next:
		var adjacent = from if from else next
		return _get_orientation_for_terminal(current, adjacent)

	# If from and next are set, check for all remaining cases
	return _get_orientation_for_intermediate_point(current, from, next)


## Get the path orientation needed to describe a path starting/ending on the [param terminal] position,
## and coming from/going to [param adjacent] position
static func _get_orientation_for_terminal(terminal: Vector2i, adjacent: Vector2i) -> MovementPath.Orientation:
	var relative: Vector2i = adjacent - terminal

	match relative:
		TOP_LEFT:
			return Orientation.CENTER_TOP_LEFT
		TOP_RIGHT:
			return Orientation.CENTER_TOP_RIGHT
		BOTTOM_LEFT:
			return Orientation.CENTER_BOTTOM_LEFT
		BOTTOM_RIGHT:
			return Orientation.CENTER_BOTTOM_RIGHT

	assert(false, "Unexpected relative point: %s %s" % [terminal, adjacent])
	return Orientation.CENTER_DOT


var intermediate_lookup: Dictionary[Array, MovementPath.Orientation] = {
	[TOP_LEFT, BOTTOM_RIGHT]: Orientation.TOP_LEFT_BOTTOM_RIGHT,
	[BOTTOM_RIGHT, TOP_LEFT]: Orientation.TOP_LEFT_BOTTOM_RIGHT,
}

## Get the path orientation needed to describe a point in the path that has
## both a predecessor and a successor
static func _get_orientation_for_intermediate_point(
	intermediate: Vector2i,
	from: Vector2i,
	next: Vector2i
) -> MovementPath.Orientation:
	if not intermediate or not from or not next:
		assert(false, "Invalid parameters. All points must be set")
		return Orientation.CENTER_DOT

	var from_relative = intermediate - from
	var next_relative = intermediate - next


	match [from_relative, next_relative]:
		# Diagonals
		[TOP_LEFT, BOTTOM_RIGHT]:
			return Orientation.TOP_LEFT_BOTTOM_RIGHT
		[BOTTOM_RIGHT, TOP_LEFT]:
			return Orientation.TOP_LEFT_BOTTOM_RIGHT

		[TOP_RIGHT, BOTTOM_LEFT]:
			return Orientation.TOP_RIGHT_BOTTOM_LEFT
		[BOTTOM_LEFT, TOP_RIGHT]:
			return Orientation.TOP_RIGHT_BOTTOM_LEFT

		# Turns
		[TOP_LEFT, TOP_RIGHT]:
			return Orientation.TOP_LEFT_TOP_RIGHT
		[TOP_RIGHT, TOP_LEFT]:
			return Orientation.TOP_LEFT_TOP_RIGHT

		[TOP_RIGHT, BOTTOM_RIGHT]:
			return Orientation.TOP_RIGHT_BOTTOM_RIGHT
		[BOTTOM_RIGHT, TOP_RIGHT]:
			return Orientation.TOP_RIGHT_BOTTOM_RIGHT

		[BOTTOM_LEFT, BOTTOM_RIGHT]:
			return Orientation.BOTTOM_LEFT_BOTTOM_RIGHT
		[BOTTOM_RIGHT, BOTTOM_LEFT]:
			return Orientation.BOTTOM_LEFT_BOTTOM_RIGHT

		[TOP_LEFT, BOTTOM_LEFT]:
			return Orientation.TOP_LEFT_BOTTOM_LEFT
		[BOTTOM_LEFT, TOP_LEFT]:
			return Orientation.TOP_LEFT_BOTTOM_LEFT


	return Orientation.CENTER_DOT
