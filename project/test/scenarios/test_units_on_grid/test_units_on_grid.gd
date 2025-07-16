extends Node2D

const SKELETON_LOC: Vector2i = Vector2i(0, 0)
const ROGUE_LOC: Vector2i = Vector2i(0, 1)
var rogue: Unit
var skeleton: Unit

@onready var battle_grid_node: BattleGridNode = %BattleGridNode


func _ready() -> void:
	skeleton = battle_grid_node.battle_grid.cells[SKELETON_LOC].unit
	rogue = battle_grid_node.battle_grid.cells[ROGUE_LOC].unit
	var player = Commander.new("player", "")
	var enemy_ai = Commander.new("PC", "", Commander.CommanderType.AI)
	var action = skeleton.actions.get(0)
	var command = ActionExecutionCommand.new(skeleton, player, action, [rogue.cell])
	test_skeleton_unit_action_points()
	test_skeleton_unit_melee_ability_action()
	#command.execute()


# Test that the skeleton unit has the correct action points
func test_skeleton_unit_action_points():
	print(skeleton.action_points_current)


# Test that the skeleton has the melee ability
func test_skeleton_unit_melee_ability_action():
	var melee_ability_action: AbilityAction
	var melee_ability_index = skeleton.get_actions().find_custom(
		func(action: UnitAction) -> bool:
			return action is AbilityAction and action.ability.name == "Melee Attack"
	)
	if melee_ability_index > -1:
		melee_ability_action = skeleton.get_actions()[melee_ability_index]
	print(melee_ability_action)
