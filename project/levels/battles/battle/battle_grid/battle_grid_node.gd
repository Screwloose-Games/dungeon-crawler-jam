class_name BattleGridNode
extends Node2D

@export var battle_grid: BattleGrid


func _ready() -> void:
	battle_grid.grid_cells_loaded.connect(_on_grid_cells_loaded)


func _on_grid_cells_loaded():
	var battlefield_scene = battle_grid.battlefield_scene.instantiate()
	add_child(battlefield_scene)


func _process(_delta: float) -> void:
	pass


func update_grid():
	pass
