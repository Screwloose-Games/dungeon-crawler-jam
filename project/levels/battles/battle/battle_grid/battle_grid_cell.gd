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

var effects: Array[EffectType]
var type: TileType
var position: Vector2i


func _init(
	position: Vector2i = Vector2i.ZERO,
	unit: Unit = null,
	type: TileType = TileType.GROUND,
	effects: Array[EffectType] = []
) -> void:
	if unit:
		unit.cell = self
	self.position = position
	self.unit = unit
	self.type = type
	self.effects = effects
