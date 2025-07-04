extends Node
class_name FiringStateMachine

## The initial state of the state machine. If not set, the first child node is used.
@export var initial_state: FiringState = null
@export var switching_state: FiringState
@export var reloading_state: FiringState

## The current state of the state machine.
@onready var previous_state: FiringState
@onready var current_state: FiringState

## Emitted when any state is changed
signal firing_state_changed(previous_state: FiringState, current_state: FiringState)

var parent: CharacterBody3D
@onready var game_weapon: Node3D = %GameWeapon
@export var current_weapon: WeaponResource = null

func init(par: CharacterBody3D) -> void:
	parent = par
	for child: FiringState in get_children():
		child.parent = par
		child.finished.connect(change_state)
	
	if initial_state:
		change_state(initial_state)
	else:
		printerr("Initial Firing State not found!")

func change_state(new_state: FiringState, data: Dictionary = {}) -> void:
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter(previous_state, data)
	firing_state_changed.emit(previous_state, current_state)
	
func request_weapon_switch_state(new_weapon_resource: WeaponResource) -> void:
	if switching_state:
		change_state(switching_state, {"new_gun": new_weapon_resource})
	else:
		printerr("This will never happen. I don't really need to describe this error.")
	

func request_weapon_reload_state() -> void:
	if reloading_state:
		change_state(reloading_state)
	else:
		printerr("This will never happen. I don't really need to describe this error.")
	

func process_physics(delta: float) -> void:
	current_state.process_physics(delta)
	
func process_input(event: InputEvent) -> void:
	current_state.process_input(event)
	
func process_frame(delta: float) -> void:
	current_state.process_frame(delta)
