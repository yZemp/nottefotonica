extends Node
class_name FiringStateMachine

## The initial state of the state machine. If not set, the first child node is used.
@export var initial_state: FiringState = null

## The current state of the state machine.
@onready var previous_state: FiringState
@onready var current_state: FiringState

## Emitted when any state is changed
signal firing_state_changed(previous_state: MovementState, current_state: MovementState)

var parent: CharacterBody3D
@onready var game_weapon: Node3D = %GameWeapon
@export var current_weapon: Weapon_resource = null

func init(par: CharacterBody3D) -> void:
	parent = par
	for child: FiringState in get_children():
		child.parent = par
		child.finished.connect(change_state)
	
	change_state(initial_state, {"new_gun": current_weapon})
	current_state.change_weapon(current_weapon)
	
func change_state(new_state: FiringState, data: Dictionary = {}) -> void:
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter(previous_state, data)
	firing_state_changed.emit(previous_state, current_state)
	
# Pass through function for the player to call
func process_physics(delta: float) -> void:
	current_state.process_physics(delta)
	
func process_input(event: InputEvent) -> void:
	current_state.process_input(event)
	
func process_frame(delta: float) -> void:
	current_state.process_frame(delta)

func _on_tmp_status_timeout() -> void:
	#print(game_weapon.weapon_data.name)
	for child in parent.hud.get_children():
		if child is BoxContainer:
			child.get_children()[0].text =  game_weapon.get_ammo_status()
