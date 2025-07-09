extends Node

#signal upgraded(stat: )
#
#enum UpgradeStat {
#ATTACK_COOLDOWN
#}

@export var points: int = 0
@export var points_until_level: Array[int] = [3]
var upgrades: Dictionary

var level_index := 0
var points_this_level: int = 0
var points_until_next_level: int = points_until_level[0]
var unspent_level_points = 0

var current_level:
	get:
		return level_index + 1

const PLAYER_BOW_UPGRADE = preload("res://resources/upgrades/player_bow_upgrade.tres")
const PLAYER_SPEAR_UPGRADE = preload("res://resources/upgrades/player_spear_upgrade.tres")
const PLAYER_SWORD_UPGRADE = preload("res://resources/upgrades/player_sword_upgrade.tres")
@onready var coin_slam: AudioStreamPlayer = %CoinSlam


func _ready() -> void:
	upgrades = {
		Weapon.WeaponType.SWORD: PLAYER_SWORD_UPGRADE,
		Weapon.WeaponType.SPEAR: PLAYER_SPEAR_UPGRADE,
		Weapon.WeaponType.BOW: PLAYER_BOW_UPGRADE,
	}

	#GlobalSignalBus.player_spent_level_point.connect(_on_player_spent_upgrade_point)
	GlobalSignalBus.coin_collected.connect(_on_coin_collected)
	GlobalSignalBus.player_progress_reset.emit(points_this_level, 0, points_until_next_level)
	GlobalSignalBus.level_reset.connect(reset)


func reset():
	level_index = 0
	points_this_level = 0
	points_until_next_level = points_until_level[0]
	unspent_level_points = 0
	for upgrade in upgrades:
		var config: WeaponUpgradeConfig = upgrades[upgrade]
		config.attack_speed = 0
		config.health = 0
		config.speed = 0


func has_unspent_points():
	return unspent_level_points > 0


func get_weapon_config(weapon_type: Weapon.WeaponType) -> WeaponUpgradeConfig:
	return upgrades.get(weapon_type, Weapon.default_weapon_upgrades)


func spend_point() -> bool:
	if has_unspent_points():
		unspent_level_points -= 1
		GlobalSignalBus.player_spent_level_point.emit()
		coin_slam.play()

		return true
	else:
		return false


func get_points_until_next_level():
	return points_until_level[level_index]


func _on_coin_collected():
	points += 1
	points_this_level += 1
	points_until_next_level -= 1
	if points_until_next_level == 0:
		level_up()
	else:
		GlobalSignalBus.player_progress_updated.emit(points_this_level)


func level_up():
	level_index += 1
	points_this_level = 0
	GlobalSignalBus.player_leveled_up.emit()
	coin_slam.play()
	unspent_level_points += 1
	points_until_next_level = get_points_until_next_level()
	GlobalSignalBus.player_progress_reset.emit(points_this_level, 0, points_until_next_level)
