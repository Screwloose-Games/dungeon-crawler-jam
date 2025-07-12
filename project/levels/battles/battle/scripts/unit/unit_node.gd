@tool
extends Node2D

@export var unit: Unit

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D


func _ready() -> void:
	animated_sprite_2d.sprite_frames = unit.sprite_frames
