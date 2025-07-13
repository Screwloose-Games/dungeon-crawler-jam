@tool
class_name GridObjectLayoutNode
extends Node2D

const UNIT_DATA_LAYER = "UnitRef"
const EFFECT_DATA_LAYER = "EffectType"
const TIME_BETWEEN_SYNCS = 10

#@export_custom(PROPERTY_HINT_NONE, "", 2) var tile_data: Dictionary[Vector2i, GridObjectCell]
@export var tile_data: Dictionary[Vector2i, GridObjectCell]
@export_tool_button("Sync TileData") var sync_tile_data_tool_button = _on_tiles_changed

var time_since_sync: float
var tooltip_warnings: Array[String]

@onready var units: TileMapLayer = $Units
@onready var effects: Node2D = $Effects

func _ready() -> void:
	# contrary to the documentation, the changed signal doesnt trigger when the tilemap is updated
	# we will register it anyway for any property changes
	# tile changes can be synced via the "Sync TileData" button in the editor
	# as well as being automatically synced every 10 seconds
	units.changed.connect(_on_tiles_changed)
	for effects_layer in effects.get_children() as Array[TileMapLayer]:
		effects_layer.changed.connect(_on_tiles_changed)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		time_since_sync += delta
		if time_since_sync >= TIME_BETWEEN_SYNCS:
			time_since_sync = 0
			_on_tiles_changed()


func _on_tiles_changed():
	print("Updating GridObjectLayout tiles data")
	tile_data = {}
	tooltip_warnings = []

	for cell_pos in units.get_used_cells():
		var data = units.get_cell_tile_data(cell_pos)
		convert_unit_data(cell_pos, data)
	for effects_layer in effects.get_children() as Array[TileMapLayer]:
		update_effects_layer(effects_layer)

	print("Total populated cells: ", len(tile_data))
	update_configuration_warnings()


## Retrieve unit reference from the TileData custom layer
func convert_unit_data(pos: Vector2i, data: TileData):
	if data == null:
		return
	var custom_data = data.get_custom_data(UNIT_DATA_LAYER)
	if not validate_unit(pos, custom_data):
		return
	var unit := custom_data as Unit
	create_or_get_cell(pos).unit = unit


## Retrieve data from all effect layers
func update_effects_layer(layer: TileMapLayer):
	for cell_pos in layer.get_used_cells():
		var data = layer.get_cell_tile_data(cell_pos)
		convert_effects_data(cell_pos, data)


## Retrieve effect from the TileData custom layer
func convert_effects_data(pos: Vector2i, data: TileData):
	if data == null:
		return
	var effect_type = data.get_custom_data(EFFECT_DATA_LAYER)
	create_or_get_cell(pos).effect.append(effect_type)


## Get the cell at the given position, create it if it does not exist
func create_or_get_cell(pos: Vector2i):
	if tile_data.has(pos):
		return tile_data[pos]
	tile_data[pos] = GridObjectCell.new()
	return tile_data[pos]


## Ensure that the data in the custom layer is actually a reference to a Unit
func validate_unit(pos: Vector2i, data: Variant) -> bool:
	if data == null:
		tooltip_warnings.append("The painted cell at %d,%d does not have a reference to a Unit" % [pos.x, pos.y])
		return false
	if data is not Unit:
		tooltip_warnings.append("The painted cell at %d,%d is not a reference to a Unit" % [pos.x, pos.y])
		return false
	return true


func _get_configuration_warnings():
	return tooltip_warnings
