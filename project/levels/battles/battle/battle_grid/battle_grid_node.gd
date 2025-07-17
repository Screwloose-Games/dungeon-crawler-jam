class_name BattleGridNode
extends Node2D

var battle_grid: BattleGrid
var battlefield: Node2D
var units: Node2D

func initialize(_battle_grid: BattleGrid):
	name = "BattleGrid"
	battle_grid = _battle_grid
	battlefield = battle_grid.battlefield_scene.instantiate()
	add_child(battlefield)
	_create_units_header_node()


func _create_units_header_node():
	units = Node2D.new()
	units.name = "Units"
	add_child(units)
	_create_unit_nodes()


func _create_unit_nodes():
	for cell in battle_grid.cells.values():
		if cell.unit:
			_create_unit_node(cell.unit)


func _create_unit_node(unit: Unit):
	print("Create unit ", unit.name)
	var unit_node = UnitNode.new()
	unit_node.initialize(unit)
	units.add_child(unit_node)
