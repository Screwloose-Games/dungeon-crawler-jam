## Represents a single cell position on the [BattleGrid] within a [Battlefield]. [br]
## Contains information about any [Unit] occupying the position and active effects. [br]
class_name BattleGridCell
extends Resource

signal updated

enum EffectType {
	EXAMPLE_EFFECT,
}

## Different types of terrain tiles that can exist on the battlefield
enum TileType {
	## Open ground that allows free movement and visibility
	GROUND,
	## Impassable barriers that block movement and line of sight
	WALL,
	## Dangerous terrain that may cause damage or prevent movement if unit can't fly
	PIT,
}

## The unit currently occupying this cell position, if any
@export var unit: Unit:
	set(val):
		if val == unit:
			return
		if val:
			val.cell = self
		unit = val
		updated.emit()
		if grid:
			grid.changed.emit()

var effects: Array[EffectType]
var type: TileType
var position: Vector2i
var grid: BattleGrid


static func grid_cells_overlap(
	cells_1: Array[BattleGridCell], cells_2: Array[BattleGridCell]
) -> bool:
	for cell_1 in cells_1:
		if cell_1 in cells_2:
			return true
	return false


static func get_overlapping_grid_cells(
	cells_1: Array[BattleGridCell], cells_2: Array[BattleGridCell]
) -> Array[BattleGridCell]:
	var overlapping_cells: Array[BattleGridCell] = []
	for cell_1 in cells_1:
		if cell_1 in cells_2:
			overlapping_cells.append(cell_1)
	return overlapping_cells


func _init(
	battle_grid: BattleGrid,
	position: Vector2i = Vector2i.ZERO,
	unit: Unit = null,
	type: TileType = TileType.GROUND,
	effects: Array[EffectType] = [],
) -> void:
	if unit:
		unit.cell = self
	self.grid = battle_grid
	self.position = position
	self.unit = unit
	self.type = type
	self.effects = effects


func get_adjacent_cells() -> Array[BattleGridCell]:
	return grid.get_adjacent_cells(self)
