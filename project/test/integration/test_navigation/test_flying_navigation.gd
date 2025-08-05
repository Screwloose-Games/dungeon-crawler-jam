extends GdUnitTestSuite

const FLYING_TEST_BATTLFIELD = preload("res://test/integration/test_navigation/flying_test_battlefield.tres")

func test_fly_same_cell():
	_try_fly(Vector2i(0, 0), Vector2i(0, 0), 1)

func test_fly_over_gap():
	_try_fly(Vector2i(2, 0), Vector2i(2, -2), 3)

func test_fly_around_wall():
	_try_fly(Vector2i(4, 0), Vector2i(4, -2), 5)

func test_fly_over_ground():
	_try_fly(Vector2i(6, 0), Vector2i(6, -2), 3)

func test_cannot_reach():
	_try_fly(Vector2i(8, 0), Vector2i(8, -2), 1)


func _try_fly(
	start_pos: Vector2i,
	target_pos: Vector2i,
	expected_length: int
):
	var battle_grid = BattleGrid.new(FLYING_TEST_BATTLFIELD, null, [])
	var start_cell = battle_grid.get_cell(start_pos)
	var end_cell = battle_grid.get_cell(target_pos)

	assert_object(start_cell).is_not_null()
	assert_object(end_cell).is_not_null()

	var path = battle_grid.get_movement_path(
		start_cell,
		end_cell,
		Movement.Method.FLY
	)

	if expected_length > 0:
		assert_object(path).is_not_null()
		assert_object(path.cell_path).is_not_null()
		assert_object(path.cell_path[0]).is_equal(start_cell)
		assert_int(path.cell_path.size()).is_equal(expected_length)
		if expected_length > 1 or start_pos == target_pos:
			assert_object(path.cell_path[-1]).is_equal(end_cell)
	else:
		assert_object(path).is_null()
