class_name CellHighlight
extends Resource

enum Type
{
	OUTLINE,
	CORNER,
	CONFIRM,
}

enum HighlightColor
{
	WHITE,
	RED,
	GREEN,
	BLUE,
}

static var highlight_tile_lookup: Dictionary[Type, Dictionary] = {
	Type.OUTLINE: {
		"source": 0,
		"coords": Vector2i(0, 1),
	},
	Type.CORNER: {
		"source": 0,
		"coords": Vector2i(1, 1),
	},
	Type.CONFIRM: {
		"source": 0,
		"coords": Vector2i(0, 0),
	}
}

static var highlight_color_alternative: Dictionary[HighlightColor, int] = {
	HighlightColor.WHITE: 0,
	HighlightColor.RED: 1,
	HighlightColor.GREEN: 2,
	HighlightColor.BLUE: 3,
}

@export var color: HighlightColor
@export var type: Type


func _init(color: HighlightColor = HighlightColor.WHITE, type: Type = Type.OUTLINE):
	self.color = color
	self.type = type


func set_on_tile_map(tile_map_layer: TileMapLayer, cell_position: Vector2i):
	var tile_data = highlight_tile_lookup[type]
	var source = tile_data["source"]
	var coords = tile_data["coords"]
	var alternative = highlight_color_alternative[color]


	tile_map_layer.set_cell(cell_position, source, coords, alternative)
