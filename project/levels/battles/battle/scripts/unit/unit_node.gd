@tool
extends Node2D

@export var unit: Unit

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D


func _ready() -> void:
	initialize()
	unit.changed.connect(_on_unit_changed)
	unit.died.connect(queue_free)


func initialize():
	animated_sprite_2d.sprite_frames = unit.sprite_frames


func _on_resource_updated():
	pass


func _on_unit_changed():
	pass


func _process(_delta: float) -> void:
	pass
	# something that upsdates each frame.. unit.movement
