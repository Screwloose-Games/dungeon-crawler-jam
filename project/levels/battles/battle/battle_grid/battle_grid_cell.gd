class_name BattleGridCell
extends Resource

enum EffectType
{
	EXAMPLE_EFFECT,
}

enum TileType {
	GROUND,
	WALL,
	PIT,
}

var unit: Unit
var effects: Array[EffectType]
var type: TileType
