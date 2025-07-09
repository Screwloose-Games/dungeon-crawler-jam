extends Area2D
class_name InteractableArea2DComponent

signal interacted(character: Character)
signal stopped_interacting

var object: Node2D

@onready var interact_label: Label = %InteractLabel

var selected = false:
	set = set_selected


func _ready():
	object = owner


func select():
	selected = true


func unselect():
	selected = false


func set_selected(val: bool):
	selected = val
	if interact_label:
		interact_label.visible = selected


func interact(player: Character):
	interacted.emit(player)
	print("interacted")
