extends Area2D
class_name InteractArea2D

signal interacted(interactable: InteractableArea2DComponent)

var tracked_nodes: Array[InteractableArea2DComponent] = []
var selected: InteractableArea2DComponent = null

var character: Character


func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	if not character:
		character = owner


func _on_area_entered(area: Area2D):
	if area is InteractableArea2DComponent:
		for tracked in tracked_nodes:
			tracked.unselect()
		tracked_nodes.append(area)
		area.select()
		selected = area


func select_closest():
	for tracked in tracked_nodes:
		tracked.unselect()
	if tracked_nodes.size() > 0:
		tracked_nodes[0].select()
		selected = tracked_nodes[0]


func _on_area_exited(area: Area2D):
	if area is InteractableArea2DComponent:
		area.unselect()
		tracked_nodes.erase(area)
		if tracked_nodes.size() > 0:
			selected = tracked_nodes[0]
			selected.select()
		else:
			selected = null

#func _process(delta):
##get_overlapping_areas()
#if Input.is_action_just_pressed("interact"):
#if selected:
#selected.interact(player)
