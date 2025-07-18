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

var animated_sprite_2d: AnimatedSprite2D
var clickable_static_body_2d: ClickableStaticBody2D


func initialize(unit: Unit):
	if not changed.is_connected(_on_unit_changed):
		changed.connect(_on_unit_changed)
	self.unit = unit


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


func _on_resource_updated():
	pass


func _on_unit_changed():
	_create_children()
	name = "Unit_" + unit.name
	if not unit.changed.is_connected(_on_unit_changed):
		unit.changed.connect(_on_unit_changed)
	if not unit.moved_to.is_connected(_on_unit_moved):
		unit.moved_to.connect(_on_unit_moved)
	if not unit.died.is_connected(queue_free):
		unit.died.connect(queue_free)
	if not unit.moved_to.is_connected(_on_unit_moved):
		unit.moved.connect(_on_unit_moved)
	animated_sprite_2d.sprite_frames = unit.sprite_frames
	init_dynamic_collision_poly()
	_on_unit_moved()


func _on_unit_moved():
	# TODO pull this from TileMapLayer instead
	# Also we probably don't want to set position when we move, rather we need
	# to obey a movement path
	var grid_transform = Transform2D(Vector2(16, 8), Vector2(-16, 8), Vector2(16, 8))
	position = grid_transform * Vector2(unit.cell.position)
	apply_scale(Vector2(.4, .4)) # Temporarily compensating for oversized placeholder art


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
