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


func _ready() -> void:
	initialize()
	changed.connect(_on_unit_changed)
	unit.changed.connect(_on_unit_changed)
	unit.died.connect(queue_free)
	clickable_static_body_2d.clicked.connect(_on_clicked)


func initialize():
	animated_sprite_2d.sprite_frames = unit.sprite_frames
	init_dynamic_collision_poly()


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
	print("unit changed")
	initialize()


func _process(_delta: float) -> void:
	pass
	# something that upsdates each frame.. unit.movement


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
