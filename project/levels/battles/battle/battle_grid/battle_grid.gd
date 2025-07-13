class_name BattleGrid
extends Resource

## Environment tiles information
@export var battlefield: Battlefield
## Unit and object placement info
@export var grid_object_layout: GridObjectLayout

var cells: Dictionary[Vector2i, BattleGridCell]
