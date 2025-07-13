@tool
extends Node2D

const MOVES_PER_SECOND: float = 2.0
const CELL_TILE_TARGETS: Array[Vector2i] = [Vector2i(0, 1), Vector2i(0, 1), Vector2i(0, 2)]
var _current_target_index: int = 0
var _start_position: Vector2
var _target_position: Vector2
var _time_elapsed: float = 0.0
var _move_duration: float = 0.0

@onready var tile_map_layer_3: TileMapLayer = $TileMapLayer3
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready():
	_move_duration = 1.0 / MOVES_PER_SECOND
	_current_target_index = 0
	_start_position = tile_map_layer_3.map_to_world(CELL_TILE_TARGETS[_current_target_index])
	sprite_2d.position = _start_position
	var next_target_index = (_current_target_index + 1) % CELL_TILE_TARGETS.size()
	_target_position = tile_map_layer_3.map_to_world(CELL_TILE_TARGETS[next_target_index])
	_time_elapsed = 0.0


func _process(delta):
	if not Engine.is_editor_hint() or CELL_TILE_TARGETS.is_empty() or MOVES_PER_SECOND <= 0:
		return
	_time_elapsed += delta
	if _time_elapsed >= _move_duration:
		_start_position = _target_position
		_current_target_index = (_current_target_index + 1) % CELL_TILE_TARGETS.size()
		var target_position_local := tile_map_layer_3.map_to_local(
			CELL_TILE_TARGETS[_current_target_index]
		)
		_target_position = tile_map_layer_3.to_global(target_position_local)
		_time_elapsed = fmod(_time_elapsed, _move_duration)
	var t = _time_elapsed / _move_duration
	sprite_2d.position = _start_position.lerp(_target_position, t)
