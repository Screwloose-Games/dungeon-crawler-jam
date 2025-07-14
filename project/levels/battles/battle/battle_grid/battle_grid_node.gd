class_name BattleGridNode
extends Node2D

var battle_grid: BattleGrid
var battlefield: Node2D

func initialize(_battle_grid: BattleGrid):
	battle_grid = _battle_grid
	battlefield = battle_grid.battlefield_scene.instantiate()
	add_child(battlefield)
