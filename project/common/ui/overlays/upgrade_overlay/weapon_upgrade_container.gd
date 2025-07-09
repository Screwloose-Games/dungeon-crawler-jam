@tool
extends MarginContainer
class_name WeaponUpgradeUiContainer

@export var weapon_image: Texture2D:
	set(val):
		weapon_image = val
		if weapon_feature_image:
			weapon_feature_image.texture = weapon_image
@export var sprite_frames: SpriteFrames:
	set(val):
		sprite_frames = val
		if weapon_feature_image:
			weapon_feature_image.sprites = sprite_frames
@export var weapon_upgrade_config: WeaponUpgradeConfig
@export var type: Weapon.WeaponType

@onready var weapon_feature_image: AnimatedTextureRect = %WeaponFeatureImage
@onready var health_row: UpgradeUiRow = %HealthRow
@onready var speed_row: UpgradeUiRow = %SpeedRow
@onready var attack_speed_row: UpgradeUiRow = %AttackSpeedRow


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_row.upgraded.connect(_on_health_upgraded)
	attack_speed_row.upgraded.connect(_on_attack_cooldown_upgraded)
	speed_row.upgraded.connect(_on_speed_upgraded)

	_reload()


func _on_health_upgraded():
	var config = PlayerProgress.get_weapon_config(type)
	config.health += 1


func _on_attack_cooldown_upgraded():
	var config = PlayerProgress.get_weapon_config(type)
	config.attack_speed += 1


func _on_speed_upgraded():
	var config = PlayerProgress.get_weapon_config(type)
	config.speed += 1


func _reload():
	weapon_feature_image.texture = weapon_image
	weapon_feature_image.sprites = sprite_frames


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
