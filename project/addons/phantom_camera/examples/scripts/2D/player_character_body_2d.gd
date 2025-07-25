extends CharacterBody2D

@onready var _player_area2d = %PlayerArea2D
@onready var _player_visuals: Node2D = %PlayerVisuals
@onready var _player_sprite: Sprite2D = %PlayerSprite
@onready var _interaction_prompt: Panel = %InteractionPrompt
@onready var _ui_sign: Control
@onready var _dark_overlay: ColorRect = %DarkOverlay

const KEY_STRINGNAME: StringName = "Key"
const ACTION_STRINGNAME: StringName = "Action"
const INPUT_MOVE_LEFT_STRINGNAME: StringName = "move_left"
const INPUT_MOVE_RIGHT_STRINGNAME: StringName = "move_right"

const SPEED = 350.0
const JUMP_VELOCITY = -750.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = 2400
var _is_interactive: bool
var _can_open_inventory: bool
var _movement_disabled: bool
var tween: Tween
var _interactive_UI: Control
var _active_pcam: PhantomCamera2D

var _physics_body_trans_last: Transform2D
var _physics_body_trans_current: Transform2D

enum InteractiveType {
	NONE = 0,
	ITEM = 1,
	INVENTORY = 2,
}
var _interactive_object: InteractiveType = InteractiveType.NONE

var InputMovementDic: Dictionary = {
	INPUT_MOVE_LEFT_STRINGNAME:
	{KEY_STRINGNAME: KEY_A, ACTION_STRINGNAME: INPUT_MOVE_LEFT_STRINGNAME},
	INPUT_MOVE_RIGHT_STRINGNAME:
	{KEY_STRINGNAME: KEY_D, ACTION_STRINGNAME: INPUT_MOVE_RIGHT_STRINGNAME},
}


func _ready() -> void:
	_player_area2d.body_shape_entered.connect(_show_prompt)
	_player_area2d.body_shape_exited.connect(_hide_prompt)

	_ui_sign = owner.get_node("%UISign")

	for input in InputMovementDic:
		var key_val = InputMovementDic[input].get(KEY_STRINGNAME)
		var action_val = InputMovementDic[input].get(ACTION_STRINGNAME)

		var movement_input = InputEventKey.new()
		movement_input.physical_keycode = key_val
		InputMap.add_action(action_val)
		InputMap.action_add_event(action_val, movement_input)

	_player_visuals.top_level = true

	if Engine.get_version_info().major == 4 and Engine.get_version_info().minor >= 3:
		printerr(
			"Please run the other 2D example scenes, in the 2D-4.3 directory, for more up-to-date example setups."
		)


func _unhandled_input(event: InputEvent) -> void:
	if _is_interactive:
		if Input.is_physical_key_pressed(KEY_F):
			if tween:
				tween.kill()

			if not _movement_disabled:
				tween = get_tree().create_tween()

				_movement_disabled = true
				_active_pcam.set_priority(10)

				_show_interactive_node(_interactive_UI)
				_interactive_node_logic()

			else:
				_hide_interactive_node(_interactive_UI)
				_interactive_node_logic()

		if Input.is_physical_key_pressed(KEY_ESCAPE) and _movement_disabled:
			_hide_interactive_node(_interactive_UI)
			_interactive_node_logic()


func _show_interactive_node(UI: Control) -> void:
	UI.modulate.a = 0
	UI.visible = true
	tween.tween_property(UI, "modulate", Color.WHITE, 1).set_ease(Tween.EASE_OUT).set_trans(
		Tween.TRANS_CIRC
	)


func _hide_interactive_node(UI: Control) -> void:
	_movement_disabled = false
	_active_pcam.set_priority(0)
	UI.visible = false


func _interactive_node_logic() -> void:
	match _interactive_object:
		2:
			if _movement_disabled:
				_dark_overlay.set_visible(true)
			else:
				_dark_overlay.set_visible(false)


func _physics_process(delta: float) -> void:
	_physics_body_trans_last = _physics_body_trans_current
	_physics_body_trans_current = global_transform

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if _movement_disabled:
		return

	var input_dir := Input.get_axis(INPUT_MOVE_LEFT_STRINGNAME, INPUT_MOVE_RIGHT_STRINGNAME)

	if input_dir:
		velocity.x = input_dir * SPEED
		if input_dir > 0:
			_player_sprite.set_flip_h(false)
		elif input_dir < 0:
			_player_sprite.set_flip_h(true)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _process(delta) -> void:
	_player_visuals.global_position = (
		_physics_body_trans_last
		. interpolate_with(_physics_body_trans_current, Engine.get_physics_interpolation_fraction())
		. origin
	)


func _show_prompt(body_rid: RID, body: Node2D, body_shape_index: int, local_shape: int) -> void:
	if body is TileMap:
		var tile_map: TileMap = body

		var tile_coords: Vector2i = tile_map.get_coords_for_body_rid(body_rid)
		var cell_data: TileData = tile_map.get_cell_tile_data(1, tile_coords)

		if cell_data:
			var cell_data_type: StringName = cell_data.get_custom_data("Type")
#			var cell_global_pos: Vector2 = tile_map.to_global(tile_map.map_to_local(tile_coords))
			_is_interactive = true
			_interaction_prompt.set_visible(true)

			match cell_data_type:
				"Sign":
					_interactive_UI = owner.get_node("%UISign")
					_active_pcam = %ItemFocusPhantomCamera2D
					_interactive_object = InteractiveType.ITEM
				"Inventory":
					_interactive_UI = owner.get_node("%UIInventory")
					_interactive_object = InteractiveType.INVENTORY
					_active_pcam = %InventoryPhantomCamera2D


func _hide_prompt(body_rid: RID, body: Node2D, body_shape_index: int, local_shape: int) -> void:
	if body is TileMap:
		var tile_map: TileMap = body

		var tile_coords: Vector2i = tile_map.get_coords_for_body_rid(body_rid)
		var cell_data: TileData = tile_map.get_cell_tile_data(1, tile_coords)

		if cell_data:
			_interaction_prompt.set_visible(false)
			_is_interactive = false
			_interactive_UI = null
			_interactive_object = InteractiveType.NONE
			_active_pcam = null
