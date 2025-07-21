class_name BattleGridNode
extends Node2D

const BATTLEFIELD_TEMPLATE = preload(
	"res://levels/battles/battle/battle_grid/battlefield/battlefield_template.tscn"
)
const UNIT_NODE_TEMPLATE = preload("res://levels/battles/battle/unit/unit_node_template.tscn")

var battle_grid: BattleGrid
var battlefield_node: BattlefieldNode

var ground_tile_map_layer: TileMapLayer


func _init(_battle_grid: BattleGrid = null) -> void:
	battle_grid = _battle_grid


func _process(_delta: float):
	_handle_mouse_input()


func _handle_mouse_input():
	var mouse_position := get_global_mouse_position()
	var tile_position = _convert_click_to_tile(mouse_position)

	if Input.is_action_just_pressed("left_click"):
		_select_cell_position(Player.commander, tile_position)
	elif Input.is_action_just_pressed("right_click"):
		_target_cell_position(Player.commander, tile_position)
	else:
		_hover_cell_position(Player.commander, tile_position)


func _convert_click_to_tile(click_position: Vector2) -> Vector2i:
	var local_position := ground_tile_map_layer.to_global(click_position)
	return ground_tile_map_layer.local_to_map(local_position)


func _select_cell_position(commander: Commander, cell_position: Vector2i):
	battle_grid.select_cell_position(commander, cell_position)


func _hover_cell_position(commander: Commander, cell_position: Vector2i):
	battle_grid.hover_cell_position(commander, cell_position)


func _target_cell_position(commander: Commander, cell_position: Vector2i):
	battle_grid.target_cell_position(commander, cell_position)


func initialize():
	name = "BattleGrid"
	battlefield_node = BATTLEFIELD_TEMPLATE.instantiate()
	battlefield_node.battlefield = battle_grid.battlefield
	if !is_node_ready():
		await ready
	add_child(battlefield_node)
	if !battlefield_node.is_node_ready():
		await battlefield_node.ready
	ground_tile_map_layer = battlefield_node.floors
	_create_unit_nodes()


func get_world_location_by_grid_location(grid_location: Vector2i):
	var local_coord: Vector2 = ground_tile_map_layer.map_to_local(grid_location)
	return ground_tile_map_layer.to_global(local_coord)


func _create_unit_nodes():
	for cell in battle_grid.cells.values():
		if cell.unit:
			_create_unit_node(cell.unit)


func _create_unit_node(unit: Unit):
	var unit_node: UnitNode = UNIT_NODE_TEMPLATE.instantiate()
	unit_node.initialize(unit)
	add_child(unit_node)
