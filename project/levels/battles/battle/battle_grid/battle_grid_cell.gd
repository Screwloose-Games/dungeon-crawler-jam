## Represents a single cell position on the [BattleGrid] within a [Battlefield]. [br]
## Contains information about any [Unit] occupying the position and active effects. [br]
class_name BattleGridCell
extends Resource

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
@export var unit: Unit
var effects: Array[EffectType]
var type: TileType


func _init(
	unit: Unit = null, type: TileType = TileType.GROUND, effects: Array[EffectType] = []
) -> void:
	if unit:
		unit.cell = self
	self.unit = unit
	self.type = type
	self.effects = effects
