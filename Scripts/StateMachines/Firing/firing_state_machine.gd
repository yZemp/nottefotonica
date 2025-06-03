extends Node
class_name FiringStateMachine

## The initial state of the state machine. If not set, the first child node is used.
@export var initial_state: FiringState = null

## The current state of the state machine.
@onready var current_state: FiringState

var parent: CharacterBody3D
@onready var game_weapon: Node3D = %GameWeapon
@export var current_weapon: Weapon_resource = null

func init(par: CharacterBody3D) -> void:
	parent = par
	for child in get_children():
		child.parent = par
	
	change_weapon(current_weapon)
	change_state(initial_state)
	
func change_state(new_state: FiringState, param = null) -> void:
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

func change_weapon(new_gun: Weapon_resource):
	parent.game_weapon.weapon_data = new_gun
	parent.game_weapon.setup_weapon()


func _on_tmp_status_timeout() -> void:
	print(game_weapon.weapon_data.name)
	print(game_weapon.get_ammo_status())
