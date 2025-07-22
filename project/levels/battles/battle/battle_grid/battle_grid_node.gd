class_name BattleGridNode
extends Node2D

const UNIT_NODE_TEMPLATE = preload("res://levels/battles/battle/unit/unit_node_template.tscn")
@onready var battlefield_node: BattlefieldNode = $Battlefield

var battle_grid: BattleGrid
var ground_tile_map_layer: TileMapLayer


func initialize(battle_grid: BattleGrid):
	self.battle_grid = battle_grid

	battlefield_node.initialize(battle_grid.battlefield)
	if !is_node_ready():
		await ready
	if !battlefield_node.is_node_ready():
		await battlefield_node.ready
	ground_tile_map_layer = battlefield_node.floors
	_create_unit_nodes()


func cell_coords_to_global_position(cell_coords: Vector2i):
	var local_coord: Vector2 = ground_tile_map_layer.map_to_local(cell_coords)
	return ground_tile_map_layer.to_global(local_coord)


func global_position_to_cell_coords(global_pos: Vector2) -> Vector2i:
	var local_position := ground_tile_map_layer.to_local(global_pos)
	return ground_tile_map_layer.local_to_map(local_position)


func _create_unit_nodes():
	for cell in battle_grid.cells.values():
		if cell.unit:
			_create_unit_node(cell.unit)


func _create_unit_node(unit: Unit):
	var unit_node: UnitNode = UNIT_NODE_TEMPLATE.instantiate()
	unit_node.initialize(unit)
	add_child(unit_node)
