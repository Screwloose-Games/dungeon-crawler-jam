@tool
extends CanvasLayer

@onready var close_button: Button = %CloseButton
@onready var sword_container: WeaponUpgradeUiContainer = %SwordContainer
@onready var spear_container: WeaponUpgradeUiContainer = %SpearContainer
@onready var bow_container: WeaponUpgradeUiContainer = %BowContainer
@onready var weapon_upgrade_panel_container: HBoxContainer = %WeaponUpgradePanelContainer

const WEAPON_UPGRADE_CONTAINER = preload(
	"res://common/ui/overlays/upgrade_overlay/weapon_upgrade_container.tscn"
)


func _ready() -> void:
	sword_container.weapon_upgrade_config = PlayerProgress.upgrades.get(Weapon.WeaponType.SWORD)
	sword_container.weapon_upgrade_config = PlayerProgress.upgrades.get(Weapon.WeaponType.SPEAR)
	sword_container.weapon_upgrade_config = PlayerProgress.upgrades.get(Weapon.WeaponType.BOW)


func _add_dynamic_panels():
	for weapon_type in PlayerProgress.upgrades:
		var config = PlayerProgress.upgrades[weapon_type]
		var new_panel = WEAPON_UPGRADE_CONTAINER.instantiate()
		new_panel.weapon_upgrade_config = config
		weapon_upgrade_panel_container.add_child(new_panel)


func _on_close_button_pressed() -> void:
	hide()
