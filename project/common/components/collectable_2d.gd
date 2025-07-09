@tool
extends Area2D
class_name Collectable2D

@export var texture: Texture2D:
	set = set_texture
@export var effects: Array[CollectableEffectResource]
@onready var sprite_2d: Sprite2D = Sprite2D.new()
@onready var collision_shape: CollisionShape2D = CollisionShape2D.new()


func _ready():
	add_child(sprite_2d)
	sprite_2d.texture = texture


func set_texture(new_texture: Texture2D):
	texture = new_texture
	if sprite_2d:
		sprite_2d.texture = texture


func get_collected(recipient: CharacterBody2D):
	for effect in effects:
		if effect.has_method("apply_effect"):
			effect.apply_effect(recipient)
	queue_free.call_deferred()
