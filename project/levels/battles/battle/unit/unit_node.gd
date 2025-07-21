@tool
class_name UnitNode
extends Node2D

signal changed
signal selected

@export var unit: Unit:
	set(new_value):
		if unit != new_value:
			unit = new_value
			changed.emit()

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var clickable_static_body_2d: ClickableStaticBody2D = $ClickableStaticBody2D
@onready var selection_sprite: AnimatedSprite2D = $SelectionSprite


func _ready():
	if not unit.move_started.is_connected(_on_unit_move_started):
		unit.move_started.connect(_on_unit_move_started)
	init_position()


func get_grid_position() -> Vector2i:
	return unit.cell.position


func move_to_location(location: Vector2i):
	self.position = location


func initialize(unit: Unit):
	if not changed.is_connected(_on_unit_changed):
		changed.connect(_on_unit_changed)
	self.unit = unit
	self.position = unit.cell.position
	GlobalSignalBus.commander_selected_unit.connect(_on_commander_selected_unit)
	GlobalSignalBus.commander_unselected_unit.connect(_on_commander_unselected_unit)


func _create_children():
	if not clickable_static_body_2d:
		clickable_static_body_2d = ClickableStaticBody2D.new()
		clickable_static_body_2d.name = "ClickableStaticBody2D"
		clickable_static_body_2d.clicked.connect(_on_clicked)
		add_child(clickable_static_body_2d)
	if not animated_sprite_2d:
		animated_sprite_2d = AnimatedSprite2D.new()
		animated_sprite_2d.name = "AnimatedSprite2D"
		add_child(animated_sprite_2d)


func init_dynamic_collision_poly():
	for child in clickable_static_body_2d.get_children():
		child.queue_free()
	for collision_poly: CollisionPolygon2D in sprite_to_polygons():
		clickable_static_body_2d.add_child(collision_poly)


func _on_clicked():
	selected.emit()
	GlobalSignalBus.unit_selected.emit(self, null)


func _on_resource_updated():
	pass


func _on_unit_changed():
	if !is_node_ready():
		await ready
	name = "Unit_" + unit.name
	if not unit.changed.is_connected(_on_unit_changed):
		unit.changed.connect(_on_unit_changed)
	if not unit.move_started.is_connected(_on_unit_move_started):
		unit.move_started.connect(_on_unit_move_started)
	if not unit.died.is_connected(queue_free):
		unit.died.connect(queue_free)
	animated_sprite_2d.sprite_frames = unit.sprite_frames
	init_dynamic_collision_poly()


func init_position():
	if not unit or not unit.cell:
		return
	var grid_transform = Transform2D(Vector2(16, 8), Vector2(-16, 8), Vector2(16, 8))
	position = grid_transform * Vector2(unit.cell.position)


func _on_unit_move_started(return_signal: ReturnSignal, cell: BattleGridCell):
	var tween = get_tree().create_tween()

	# Inform unit that we are animating the movement,
	# and it should wait until we are done to complete the move
	return_signal.register_blocker()

	var grid_transform = Transform2D(Vector2(16, 8), Vector2(-16, 8), Vector2(16, 8))
	var target_position = grid_transform * Vector2(cell.position)
	tween.tween_property(self, "position", target_position, 1.0 / unit.move_speed)
	var prev_position = position
	if target_position.x > prev_position.x:
		start_moving_right()
	elif target_position.x < prev_position.x:
		start_moving_left()
	await tween.finished
	return_signal.complete_blocker()


func sprite_to_polygons() -> Array[CollisionPolygon2D]:
	var first_idle_frame: Texture2D = animated_sprite_2d.sprite_frames.get_frame_texture("idle", 0)
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(first_idle_frame.get_image())
	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, first_idle_frame.get_size()), 2.0)
	var collision_polygons: Array[CollisionPolygon2D]
	for poly in polys:
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = poly
		collision_polygons.append(collision_polygon)
		if animated_sprite_2d.centered:
			collision_polygon.position = (
				Vector2i(collision_polygon.position) - bitmap.get_size() / 2
			)
	return collision_polygons


func start_moving_right():
	transform.x.x = 1.0
	animated_sprite_2d.play("move_right")


func start_moving_left():
	transform.x.x = -1.0
	animated_sprite_2d.play("move_right")


func _on_commander_selected_unit(unit: Unit):
	if self.unit == unit:
		selection_sprite.visible = true


func _on_commander_unselected_unit(unit: Unit):
	if self.unit == unit:
		selection_sprite.visible = false
