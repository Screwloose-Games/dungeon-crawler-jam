## Stores battle-related state such as what unit and action is selected
## All state is considered ephemeral and is Player-specific
class_name CommanderBattleUiState
extends Node

signal updated

var selected_unit: Unit:
	get:
		if selected_grid_cell and selected_grid_cell.unit:
			return selected_grid_cell.unit
		return null
var selected_grid_cell: BattleGridCell:
	set(new_val):
		if new_val != selected_grid_cell:
			updated.emit()

var selected_action: UnitAction


func _ready() -> void:
	GlobalSignalBus.battle_grid_cell_selected.connect(_on_battle_grid_cell_selected)


func _on_battle_grid_cell_selected(battle_grid_cell: BattleGridCell, _commander: Commander):
	selected_grid_cell = battle_grid_cell
