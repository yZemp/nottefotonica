extends Node
class_name StateMachine

## The initial state of the state machine. If not set, the first child node is used.
@export var initial_state: MovementState = null

## The current state of the state machine.
@onready var current_state: MovementState

var parent: CharacterBody3D

func init(parent: CharacterBody3D) -> void:
	for child in get_children():
		child.parent = parent
	change_state(initial_state)
	
func change_state(new_state: MovementState) -> void:
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
