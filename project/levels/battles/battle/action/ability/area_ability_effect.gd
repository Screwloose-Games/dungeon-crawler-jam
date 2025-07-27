## An [AbilityEffect] wrapper for spells that affect multiple cells. [br]
## The given [AbilityEffect] will be applied to all cells defined in the [member tile_offsets]. [br]
class_name AreaAbilityEffect
extends AbilityEffect

## Array of tile offsets relative to the target position that define the area of effect
@export var tile_offsets: Array[Vector2i]
## The effect to apply to each tile in the defined area
@export var effect: AbilityEffect


func preview(command: ActionExecutionCommand, preview: ActionPreviewData):
	var sub_command = get_new_command(command)
	effect.preview(sub_command, preview)


## Applies the wrapped effect to all tiles in the defined area. [br]
## Each tile position is calculated as target position plus each offset. [br]
func apply(command: ActionExecutionCommand, return_signal: ReturnSignal):
	var sub_command = get_new_command(command)
	effect.apply(sub_command, return_signal)


func get_new_command(command: ActionExecutionCommand) -> ActionExecutionCommand:
	var sub_command = command.clone()
	sub_command.targets.clear()

	for target in command.targets:
		for offset in tile_offsets:
			var new_target_position = target.position + offset
			var new_target_cell = command.battle_grid.get_cell(new_target_position)

			if new_target_cell:
				sub_command.targets.append(new_target_cell)

	return sub_command
