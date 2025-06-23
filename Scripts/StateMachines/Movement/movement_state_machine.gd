extends Node
class_name MovementStateMachine

## The initial state of the state machine. If not set, the first child node is used.
@export var initial_state: MovementState = null

## The current state of the state machine.
@onready var previous_state: MovementState
@onready var current_state: MovementState

## Emitted when any state is changed
signal movement_state_changed(previous_state: MovementState, current_state: MovementState)

var parent: CharacterBody3D

func init(par: CharacterBody3D) -> void:
	parent = par
	for child: MovementState in get_children():
		child.parent = par
		child.finished.connect(change_state)
	change_state(initial_state)

func change_state(new_state: MovementState, data: Dictionary = {}) -> void:
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter(previous_state, data)
	movement_state_changed.emit(previous_state, current_state)

# Pass through function for the player to call
func process_physics(delta: float) -> void:
	current_state.process_physics(delta)

func process_input(event: InputEvent) -> void:
	current_state.process_input(event)

func process_frame(delta: float) -> void:
	current_state.process_frame(delta)
