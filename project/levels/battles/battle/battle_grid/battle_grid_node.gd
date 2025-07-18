class_name BattleGridNode
extends Node2D

const BATTLEFIELD_TEMPLATE = preload(
	"res://levels/battles/battle/battle_grid/battlefield/battlefield_template.tscn"
)
const UNIT_NODE_TEMPLATE = preload("res://levels/battles/battle/unit/unit_node_template.tscn")

var battle_grid: BattleGrid
var battlefield_node: BattlefieldNode


func initialize(_battle_grid: BattleGrid):
	name = "BattleGrid"
	battle_grid = _battle_grid
	battlefield_node = BATTLEFIELD_TEMPLATE.instantiate()
	battlefield_node.battlefield = battle_grid.battlefield
	add_child(battlefield_node)
	_create_unit_nodes()


func _create_unit_nodes():
	for cell in battle_grid.cells.values():
		if cell.unit:
			_create_unit_node(cell.unit)


func _create_unit_node(unit: Unit):
	var unit_node: UnitNode = UNIT_NODE_TEMPLATE.instantiate()
	unit_node.initialize(unit)
	add_child(unit_node)
