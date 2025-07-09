@tool

extends TextureRect
class_name UpgradePowerIncrement

@export var off_texture: Texture2D:
	set(val):
		off_texture = val
		custom_minimum_size = custom_minimum_size.max(val.get_size())

@export var on_texture: Texture2D:
	set(val):
		on_texture = val
		custom_minimum_size = custom_minimum_size.max(val.get_size())

@export var on: bool = false:
	set(val):
		on = val
		if on:
			texture = on_texture
		else:
			texture = off_texture


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custom_minimum_size = on_texture.get_size().max(off_texture.get_size())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
