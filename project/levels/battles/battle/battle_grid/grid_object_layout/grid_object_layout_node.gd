@tool
class_name GridObjectLayoutNode
extends Node2D

const UNIT_DATA_LAYER = "UnitRef"
const EFFECT_DATA_LAYER = "EffectType"

@export_custom(PROPERTY_HINT_NONE, "", 2) var tile_data: Dictionary[Vector2i, GridObjectCell]
@onready var units: TileMapLayer = $Units
@onready var effects: Node2D = $Effects


func _ready() -> void:
	units.changed.connect(_on_tiles_changed)
	for effects_layer in effects.get_children() as Array[TileMapLayer]:
		effects_layer.changed.connect(_on_tiles_changed)


func _on_tiles_changed():
	tile_data = {}
	for cell_pos in units.get_used_cells():
		var data = units.get_cell_tile_data(cell_pos)
		convert_unit_data(cell_pos, data)
	for effects_layer in effects.get_children() as Array[TileMapLayer]:
		update_effects_layer(effects_layer)


func convert_unit_data(pos: Vector2i, data: TileData):
	var unit = data.get_custom_data(UNIT_DATA_LAYER) as Unit
	create_or_get_cell(pos).unit = unit


func update_effects_layer(layer: TileMapLayer):
	for cell_pos in layer.get_used_cells():
		var data = layer.get_cell_tile_data(cell_pos)
		convert_effects_data(cell_pos, data)


func convert_effects_data(pos: Vector2i, data: TileData):
	var effect_type = data.get_custom_data(EFFECT_DATA_LAYER)
	create_or_get_cell(pos).effect.append(effect_type)


func create_or_get_cell(pos: Vector2i):
	if tile_data.has(pos):
		return tile_data[pos]
	tile_data[pos] = GridObjectCell.new()
	return tile_data[pos]
