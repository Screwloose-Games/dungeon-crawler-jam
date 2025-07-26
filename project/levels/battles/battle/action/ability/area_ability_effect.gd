## An [AbilityEffect] wrapper for spells that affect multiple cells. [br]
## The given [AbilityEffect] will be applied to all cells defined in the [member tile_offsets]. [br]
class_name AreaAbilityEffect
extends AbilityEffect

## Array of tile offsets relative to the target position that define the area of effect
@export var tile_offsets: Array[Vector2i]
## The effect to apply to each tile in the defined area
@export var effect: AbilityEffect


func preview(command: ActionExecutionCommand, preview: ActionPreviewData):
	pass


## Applies the wrapped effect to all tiles in the defined area. [br]
## Each tile position is calculated as target position plus each offset. [br]
func apply(_order: ActionExecutionCommand, _return_signal: ReturnSignal):
	pass
