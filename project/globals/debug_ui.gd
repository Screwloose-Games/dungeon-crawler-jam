extends CanvasLayer

const END_TIMELINE_LABEL: String = "skip"

#@onready var player_speed_label: Label = %PlayerSpeedLabel
#@onready var player_speed_line_edit: LineEdit = %PlayerSpeedLineEdit
#@onready var give_resources_button: Button = %GiveResourcesButton
#@onready var unlock_structures_button: Button = %UnlockStructuresButton
#@onready var update_resources_component: UpdateResourcesComponent = %UpdateResourcesComponent
#@onready var unlock_structures_component: UnlockStructuresComponent = %UnlockStructuresComponent
#@onready var debug_ui_margin_container: PanelContainer = %DebugUIContainer
#@onready var label_margin_container: MarginContainer = %LabelMarginContainer

#
#
#func _ready() -> void:
#hide()
#debug_ui_margin_container.hide()
#player_speed_line_edit.text_submitted.connect(_on_speed_updated)
#give_resources_button.pressed.connect(_on_give_resources_pressed)
#unlock_structures_button.pressed.connect(_on_unlock_structures_pressed)
#debug_ui_margin_container.visibility_changed.connect(_on_visibility_changed)
#
#if OS.is_debug_build():
#show()
#
#
#func _process(_delta: float) -> void:
#if not OS.is_debug_build():
#return
#if Input.is_action_just_pressed("Debug"):
#visible = !visible
#debug_ui_margin_container.visible = visible
#if Input.is_action_just_pressed("Skip"):
#skip_to_timeline_end()
#
#
#func skip_to_timeline_end():
#if Dialogic.current_timeline != null:
#var timeline: DialogicTimeline = Dialogic.current_timeline
#var events: Array = timeline.events
#var d_events: Array[DialogicEvent] = []
#d_events.append_array(events)
#var lbl_index = d_events.find_custom(
#func(event: DialogicEvent):
#return event is DialogicLabelEvent and event.name == END_TIMELINE_LABEL
#)
#if lbl_index != -1:
#Dialogic.Jump.jump_to_label(END_TIMELINE_LABEL)
#
#
#func _on_visibility_changed():
#if debug_ui_margin_container.visible:
#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#var player: Player = get_tree().get_first_node_in_group("Player")
#if player:
#player_speed_line_edit.text = str(player.speed)
#else:
#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#
#
#func _on_speed_updated(new_text: String) -> void:
#var new_speed := new_text.to_float()
#var player: Player = get_tree().get_first_node_in_group("Player")
#player.speed = new_speed
#
#
#func _on_give_resources_pressed() -> void:
#update_resources_component.give_resources()
#
#
#func _on_unlock_structures_pressed() -> void:
#unlock_structures_component.unlock_structures()
