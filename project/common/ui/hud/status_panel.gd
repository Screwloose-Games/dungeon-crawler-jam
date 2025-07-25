extends MarginContainer

# Just have hp/ap count hardcoded for now
const hp_segments: int = 30
const hp_size: int = 3
const ap_segments: int = 10
const ap_size: int = 10

var hp_width: int
var ap_width: int

@onready var character_portrait: TextureRect = $CharacterPaneBack/CharacterPortrait
@onready var hp_clip_area: Control = $CharacterPaneBack/HPClipArea
@onready var ap_clip_area: Control = $CharacterPaneBack/APClipArea
@onready var character_name: RichTextLabel = $CharacterPaneBack/CharaterNameMargin/CharacterName

func _ready():
	GlobalSignalBus.unit_selected.connect(_on_unit_selected)


func _on_unit_selected(unit: Unit):
	pass#hp_clip_area.set_size(Vector2(hp_cli))
	

func set_hp():
	pass#hp_clip
