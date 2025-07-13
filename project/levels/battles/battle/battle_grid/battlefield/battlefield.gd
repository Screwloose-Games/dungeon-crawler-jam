## Represents the physical environment where a [Battle] takes place. [br]
## Defines the terrain layout, tile types, and environmental conditions that affect gameplay. [br]
## Used by [Commander] units to make tactical decisions about [Unit] positioning and movement. [br]
## Contains the scene data that defines the visual and functional aspects of the battlefield.
class_name Battlefield
extends Resource

## Different types of terrain tiles that can exist on the battlefield
enum TileType {
	## Open ground that allows free movement and visibility
	GROUND,
	## Impassable barriers that block movement and line of sight
	WALL,
	## Dangerous terrain that may cause damage or prevent movement if unit can't fly
	PIT,
}

## The scene containing the visual representation and tile data for this battlefield
@export var scene: PackedScene


## Extracts tile data from the battlefield scene to create a spatial layout map. [br]
## Creates an instance of the scene and retrieves the tile type information [br]
## for each position on the battlefield grid. [br]
## [br]
## [b]Returns:[/b] A dictionary mapping grid positions to their corresponding tile types.
func get_tile_data() -> Dictionary[Vector2i, BattleGridCell.TileType]:
	var instance: BattlefieldNode = scene.instantiate()
	return instance.tile_data
