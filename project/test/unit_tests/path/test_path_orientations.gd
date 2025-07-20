class_name PathOrientationsTest
extends GdUnitTestSuite

# Redefintions for ease of use
const CENTER_DOT = MovementPath.Orientation.CENTER_DOT
const CENTER_TOP_RIGHT = MovementPath.Orientation.CENTER_TOP_RIGHT
const CENTER_TOP_LEFT = MovementPath.Orientation.CENTER_TOP_LEFT
const CENTER_BOTTOM_RIGHT = MovementPath.Orientation.CENTER_BOTTOM_RIGHT
const CENTER_BOTTOM_LEFT = MovementPath.Orientation.CENTER_BOTTOM_LEFT
const TOP_RIGHT_BOTTOM_LEFT = MovementPath.Orientation.TOP_RIGHT_BOTTOM_LEFT
const TOP_LEFT_BOTTOM_RIGHT = MovementPath.Orientation.TOP_LEFT_BOTTOM_RIGHT
const BOTTOM_LEFT_BOTTOM_RIGHT = MovementPath.Orientation.BOTTOM_LEFT_BOTTOM_RIGHT
const TOP_LEFT_TOP_RIGHT = MovementPath.Orientation.TOP_LEFT_TOP_RIGHT
const TOP_LEFT_BOTTOM_LEFT = MovementPath.Orientation.TOP_LEFT_BOTTOM_LEFT
const TOP_RIGHT_BOTTOM_RIGHT = MovementPath.Orientation.TOP_RIGHT_BOTTOM_RIGHT


func test_straight_lines():
	check_path(
		[
			Vector2i(0, 0),
			Vector2i(0, -1),
			Vector2i(0, -2),
		],
		[
			CENTER_TOP_RIGHT,
			TOP_RIGHT_BOTTOM_LEFT,
			CENTER_BOTTOM_LEFT,
		]
	)
	check_path(
		[
			Vector2i(-2, -2),
			Vector2i(-1, -2),
			Vector2i(0, -2),
			Vector2i(1, -2),
		],
		[
			CENTER_BOTTOM_RIGHT,
			TOP_LEFT_BOTTOM_RIGHT,
			TOP_LEFT_BOTTOM_RIGHT,
			CENTER_TOP_LEFT,
		]
	)


func test_turns():
	check_path(
		[
			Vector2i(-4, 20),
			Vector2i(-4, 19),
			Vector2i(-3, 19),
		],
		[
			CENTER_TOP_RIGHT,
			BOTTOM_LEFT_BOTTOM_RIGHT,
			CENTER_TOP_LEFT,
		]
	)
	check_path(
		[
			Vector2i(0, 0),
			Vector2i(1, 0),
			Vector2i(1, 1),
		],
		[
			CENTER_BOTTOM_RIGHT,
			TOP_LEFT_BOTTOM_LEFT,
			CENTER_TOP_RIGHT,
		]
	)
	check_path(
		[
			Vector2i(3, 5),
			Vector2i(4, 5),
			Vector2i(4, 4),
		],
		[
			CENTER_BOTTOM_RIGHT,
			TOP_LEFT_TOP_RIGHT,
			CENTER_BOTTOM_LEFT,
		]
	)
	check_path(
		[
			Vector2i(25, 2),
			Vector2i(25, 3),
			Vector2i(26, 3),
		],
		[
			CENTER_BOTTOM_LEFT,
			TOP_RIGHT_BOTTOM_RIGHT,
			CENTER_TOP_LEFT,
		]
	)


func check_path(
	path_positions: Array[Vector2i],
	expected_orientations: Array[MovementPath.Orientation]
):
	var expected_path: Dictionary[Vector2i, MovementPath.Orientation] = {}
	for i in len(path_positions):
		expected_path[path_positions[i]] = expected_orientations[i]

	var path = create_path_from_positions(path_positions)
	var orientations = path.get_path_orientations()
	assert_dict(orientations).is_equal(expected_path)

	# We should get the same orientations even if we create the path backwards
	path_positions.reverse()
	path = create_path_from_positions(path_positions)
	orientations = path.get_path_orientations()
	assert_dict(orientations).is_equal(expected_path)


func create_path_from_positions(positions: Array[Vector2i]) -> MovementPath:
	var cells: Array[BattleGridCell] = []
	for position in positions:
		cells.append(BattleGridCell.new(position))
	return MovementPath.new(cells)
