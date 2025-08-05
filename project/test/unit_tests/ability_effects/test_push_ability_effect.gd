class_name TestPushAbilityEffect
extends GdUnitTestSuite


func test_apply_method_along_cardinals() -> void:
	_test_push(
		# caster is centered
		Vector2i(0, 0),
		# target unit is to the right
		Vector2i(2, 0),
		# push them two away
		[Vector2i(0, 1), Vector2i(0, 1)],
		# Expect they land two to the right
		Vector2i(4, 0),
		# ground tiles along expected path
		[Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0), Vector2i(4, 0)],
		# reorient
		true
	)

	_test_push(
		# caster is centered
		Vector2i(0, 0),
		# target unit is to the left
		Vector2i(-2, 0),
		# pull them towards the caster
		[Vector2i(0, -1), Vector2i(0, -1)],
		# Expect they land one to the right, since caster occupies origin
		Vector2i(-1, 0),
		# ground tiles along expected path
		[Vector2i(0, 0), Vector2i(-1, 0), Vector2i(-2, 0)],
		# reorient
		true
	)

	_test_push(
		# caster is to the right
		Vector2i(5, 0),
		# target unit is up
		Vector2i(5, 10),
		# push them towards the right
		[Vector2i(1, 0)],
		# Expect they land one to the right
		Vector2i(6, 10),
		# ground tiles along expected path
		[Vector2i(5, 0), Vector2i(5, 10), Vector2i(6, 10)],
		# reorient
		true
	)

	_test_push(
		# caster is to the upper-left
		Vector2i(-5, 5),
		# target unit is down
		Vector2i(-5, 0),
		# push them down
		[Vector2i(0, -1), Vector2i(0, -1), Vector2i(0, -1), Vector2i(0, -1), Vector2i(0, -1)],
		# Expect they land five further
		Vector2i(-5, -5),
		# ground tiles along expected path
		[
			Vector2i(-5, 5),
			Vector2i(-5, 0),
			Vector2i(-5, -1),
			Vector2i(-5, -2),
			Vector2i(-5, -3),
			Vector2i(-5, -4),
			Vector2i(-5, -5)
		],
		# not reoriented
		false
	)


func test_apply_diagonals():
	_test_push(
		# caster is centered
		Vector2i(0, 0),
		# target unit is upper right
		Vector2i(2, 2),
		# push them diagonally back-left
		[Vector2i(-1, 1)],
		# Expect they land on the new spot
		# diagonally back-left from this angle turns into 1 up
		Vector2i(2, 3),
		# ground tiles along expected path
		[Vector2i(0, 0), Vector2i(2, 2), Vector2i(2, 3)],
		# reorient
		true
	)

	_test_push(
		# caster is centered
		Vector2i(5, 0),
		# target unit is below caster
		Vector2i(5, -2),
		# pull them closer and left
		[Vector2i(-1, -1)],
		# Expect they land on the new spot
		Vector2i(6, -1),
		# ground tiles along expected path
		[Vector2i(5, 0), Vector2i(5, -2), Vector2i(6, -1)],
		# reorient
		true
	)

	_test_push(
		# caster is centered
		Vector2i(0, 0),
		# target is bottom left
		Vector2i(-5, -5),
		# pull them closer
		[Vector2i(0, -1), Vector2i(0, -1), Vector2i(0, -1), Vector2i(0, -1), Vector2i(0, -1)],
		# Expect they land on the new spot
		Vector2i(-1, -1),
		# ground tiles along expected path
		[
			Vector2i(-5, -5),
			Vector2i(-4, -4),
			Vector2i(-3, -3),
			Vector2i(-2, -2),
			Vector2i(-1, -1),
			Vector2i(0, 0)
		],
		# reorient
		true
	)

	_test_push(
		# caster is centered
		Vector2i(0, 0),
		# target is top left
		Vector2i(-5, 5),
		# pull them diagonal up-right
		[Vector2i(1, 1)],
		# Expect they land on the new spot
		Vector2i(-4, 6),
		# ground tiles along expected path
		[Vector2i(0, 0), Vector2i(-5, 5), Vector2i(-4, 6)],
		# do not reorient
		false
	)


func _test_push(
	caster_position: Vector2i,
	target_position: Vector2i,
	push_offsets: Array[Vector2i],
	expected_landing: Vector2i,
	ground_tiles: Array[Vector2i],
	reorient: bool,
):
	var tiles: Array[Vector2i] = [caster_position, target_position]
	tiles.append_array(push_offsets)
	tiles.append_array(ground_tiles)

	# Setup the scenario
	var battle_grid := TestHelper.get_grid_with_tiles(tiles)
	var caster := Unit.new()
	var target := Unit.new()
	caster.cell = battle_grid.get_cell(caster_position)
	target.cell = battle_grid.get_cell(target_position)

	# Setup the effect
	var effect := PushAbilityEffect.new()
	effect.reorient = reorient
	effect.push_offsets = push_offsets

	# Setup the command
	var command := ActionExecutionCommand.new()
	command.battle_grid = battle_grid
	command.unit = caster
	command.targets = [target.cell]

	# Execute the command
	var returned: Array[bool] = [false]
	var return_signal = ReturnSignal.new(func(): returned[0] = true)
	effect.apply(command, return_signal)

	# Ensure unit was pushed
	assert_vector(target.cell.position).is_equal(expected_landing)