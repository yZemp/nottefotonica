extends Node
class_name FiringStateMachine

## The initial state of the state machine. If not set, the first child node is used.
@export var initial_state: FiringState = null

## The current state of the state machine.
@onready var current_state: FiringState

var parent: CharacterBody3D
@onready var timer: Timer = $Timer

func init(par: CharacterBody3D) -> void:
	parent = par
	for child in get_children():
		child.parent = par
	
	parent.weapon.init()
	change_gun(parent.weapon.scene.instantiate())
	change_state(initial_state)
	
func change_state(new_state: FiringState) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	new_state.enter()
	
# Pass through function for the player to call
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state: change_state(new_state)
	
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state: change_state(new_state)
	
func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state: change_state(new_state)


func change_gun(new_gun: Node3D):
	if parent.hand_mount.get_child_count() > 0:
		parent.hand_mount.get_child(0).queue_free()
	new_gun.transform = Transform3D.IDENTITY
	parent.hand_mount.add_child(new_gun)
