## The UI state for a given commmander.
## Only shows the state for the current, human commander.

class_name UnitPortraitPanelContainer
extends PanelContainer

@onready var unit_portrait_texture_rect: TextureRect = %UnitPortraitTextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
