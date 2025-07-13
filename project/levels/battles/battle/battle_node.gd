extends Node2D

@export var battle: Battle
@onready var battlefield_placeholder: Node2D = %BattlefieldPlaceholder


func _ready() -> void:
	var cells: Array[Vector2i] = battle.battlefield.test_get_grid()
