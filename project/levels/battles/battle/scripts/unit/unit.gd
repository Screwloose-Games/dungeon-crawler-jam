class_name Unit
extends Resource

signal died

@export var name: String:
	set(val):
		name = val
		emit_changed()
@export var description: String
@export var abilities: Array[Ability]
@export var movement: Movement
@export var sprite_frames: SpriteFrames:
	set(val):
		sprite_frames = val
		emit_changed()
@export var portrait: Texture2D


func hurt():
	died.emit()
