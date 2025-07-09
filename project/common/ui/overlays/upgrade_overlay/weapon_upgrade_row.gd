@tool
extends HBoxContainer
class_name UpgradeUiRow

signal upgraded

@export var icon: Texture2D:
	set(val):
		icon = val
		if icon and upgrade_icon:
			upgrade_icon.texture = icon
@export var max_upgrade_level: int = 3
@export var upgrade_level: int = 0:
	set(val):
		upgrade_level = clamp(val, 0, max_upgrade_level)

@onready var upgrade_icon: TextureRect = %UpgradeIcon
@onready var power_increment: UpgradePowerIncrement = %PowerIncrement
@onready var power_increment_2: UpgradePowerIncrement = %PowerIncrement2
@onready var power_increment_3: UpgradePowerIncrement = %PowerIncrement3
@onready var upgrade_button: Button = %UpgradeButton

var weapon_type: Weapon.WeaponType


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade_button.pressed.connect(_on_upgrade_button_pressed)
	_reload()


func _on_upgrade_button_pressed():
	var success = PlayerProgress.spend_point()
	if success:
		upgrade_level += 1
		if upgrade_level >= 3:
			upgrade_button.hide()
		upgraded.emit()
		_reload()


func _reload():
	upgrade_icon.texture = icon
	var increments = [power_increment, power_increment_2, power_increment_3]
	for i in increments.size():
		if upgrade_level > i:
			(increments[i] as UpgradePowerIncrement).on = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
