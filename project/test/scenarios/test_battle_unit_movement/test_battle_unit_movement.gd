## Tests battle_template.battle_grid_node.battle_grid.try_set_unit(next_grid_position, test_unit_node.unit)
extends Node2D

var test_unit_node: UnitNode
var current_grid_index: int = -1
var movement_timer: float = 0.0
var movement_duration: float = 1.0

var grid_locations: Array[Vector2i] = [
	Vector2i(12, 1), Vector2i(12, 2), Vector2i(13, 2), Vector2i(13, 1)
]

@onready var battle_template: BattleNode = %BattleTemplate
@onready var battle_grid: BattleGrid = battle_template.battle_grid_node.battle_grid


func _ready() -> void:
	test_unit_node = get_first_unit_in_tree()


func get_first_unit_in_tree() -> UnitNode:
	return _find_unit_node_recursive(self)


func _find_unit_node_recursive(node: Node) -> UnitNode:
	if node is UnitNode:
		return node as UnitNode
	for child in node.get_children():
		var result = _find_unit_node_recursive(child)
		if result != null:
			return result
	return null


func _process(delta: float) -> void:
	if not test_unit_node:
		return
	if grid_locations.is_empty():
		return
	movement_timer += delta
	if movement_timer >= movement_duration:
		var next_grid_position_index = (current_grid_index + 1) % grid_locations.size()
		var next_grid_position: Vector2i = grid_locations[next_grid_position_index]
		battle_template.battle_grid_node.battle_grid.try_set_unit(
			next_grid_position, test_unit_node.unit
		)
		current_grid_index = next_grid_position_index
		movement_timer = 0.0
