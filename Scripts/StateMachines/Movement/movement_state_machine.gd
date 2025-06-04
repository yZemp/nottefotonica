extends Node
class_name MovementStateMachine

## The initial state of the state machine. If not set, the first child node is used.
@export var initial_state: MovementState = null

## The current state of the state machine.
@onready var current_state: MovementState

var parent: CharacterBody3D

func init(parent: CharacterBody3D) -> void:
	for child: MovementState in get_children():
		child.parent = parent
		child.finished.connect(change_state)
	change_state(initial_state)
	
	
func change_state(new_state: MovementState, data: Dictionary = {}) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	new_state.enter(data)
	
# Pass through function for the player to call
func process_physics(delta: float) -> void:
	current_state.process_physics(delta)
	
func process_input(event: InputEvent) -> void:
	current_state.process_input(event)
	
func process_frame(delta: float) -> void:
	current_state.process_frame(delta)
