extends GdUnitTestSuite

const WALKING_TEST_BATTLFIELD = preload("res://test/integration/test_navigation/walking_test_battlefield.tres")

func test_navigate_same_cell():
	_try_walk(Vector2i(0,0), Vector2i(0,0), 1)

func test_walk_one_cell():
	_try_walk(Vector2i(2,0), Vector2i(2,-1), 2)
	
func test_walk_line():
	_try_walk(Vector2i(4,0), Vector2i(4, -4), 5)
	
func test_walk_long_line():
	_try_walk(Vector2i(6,0), Vector2i(6, 10), 11)
	
func test_walk_bend():
	_try_walk(Vector2i(8,0), Vector2i(12, -4), 9)
	
func test_walk_zig_zag():
	_try_walk(Vector2i(10,0), Vector2i(11, 9), 17)
	
func test_walk_shorter_path():
	_try_walk(Vector2i(12,0), Vector2i(14, -7), 10)

func test_try_walk_blocked_path():
	_try_walk(Vector2i(14,0), Vector2i(14, 5), 0)
	
func test_walk_around_wall():
	_try_walk(Vector2i(16,0), Vector2i(16,5), 10)

func _try_walk(
	start_pos: Vector2i, 
	target_pos: Vector2i, 
	expected_length: int
):
	var battle_grid = BattleGrid.new(WALKING_TEST_BATTLFIELD, null, [])
	var start_cell = battle_grid.get_cell(start_pos)
	var end_cell = battle_grid.get_cell(target_pos)
	
	assert_object(start_cell).is_not_null()
	assert_object(end_cell).is_not_null()
	
	var path = battle_grid.get_movement_path(
		start_cell, 
		end_cell, 
		Movement.MovementMethod.WALK
	)
	
	
	if expected_length > 0:
		assert_object(path).is_not_null()
		assert_object(path.cell_path).is_not_null()
		assert_object(path.cell_path[0]).is_equal(start_cell)
		assert_object(path.cell_path[-1]).is_equal(end_cell)
		assert_int(path.cell_path.size()).is_equal(expected_length)
	else:
		assert_object(path).is_null()
	
