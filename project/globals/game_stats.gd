extends Node

var score: int = 0:
	set = set_score
@onready var player: Player:
	get = get_player
@onready var world: Node2D

@export var survival_bonus: int = 300
@export var boss_points: int = 700
@export var collectable_points: int = 5

signal minion_died(minion: CharacterBody2D)
signal world_changed(world: Node2D)
signal score_changed(score: int)
signal player_ready(player: Player)
signal player_survived(player: Player)
signal boss_died
#signal collectable_collected(collectable: Collectable3D)


# Called when the node enters the scene tree for the first time.
func _ready():
	#collectable_collected.connect(_on_collectable_collected)
	minion_died.connect(_on_minion_died)
	world_changed.connect(_on_world_changed)
	player_survived.connect(_on_player_survived)


func _on_boss_died(_boss):
	score += boss_points


func _on_collectable_collected(_boss):
	score += collectable_points


func set_score(val):
	score = val
	score_changed.emit(score)


func get_player():
	if not player:
		player = get_tree().get_first_node_in_group("Player")
	return player


func _on_world_changed(new_world: Node2D):
	world = new_world


func _on_minion_died(_minion: CharacterBody2D):
	score += 1


func reset_score():
	score = 0


func _on_player_survived(_player):
	score += survival_bonus
