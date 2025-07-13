## Represents a single cell position on the [BattleGrid] within a [Battlefield]. [br]
## Contains information about any [Unit] occupying the position and active effects. [br]
class_name BattleGridCell
extends Resource

enum EffectType {
	EXAMPLE_EFFECT,
}

enum TileType {
	GROUND,
	WALL,
	PIT,
}


## The unit currently occupying this cell position, if any
var unit: Unit
var effects: Array[EffectType]
var type: TileType
