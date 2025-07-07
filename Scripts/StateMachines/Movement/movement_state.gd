## Virtual base class for all states.
## Extend this class and override its methods to implement a state.
extends Node
class_name MovementState

var statename: String = ""

## Emitted when the state finishes and wants to transition to another state.
signal finished(next_state: String, data: Dictionary)

var gravity: int = ProjectSettings.get_setting("physics/3d/default_gravity")
var parent: CharacterBody3D

## Called by the state machine when receiving unhandled input events.
func process_input(_event: InputEvent) -> void:
	#Rotating parent and camera
	if _event is InputEventMouseMotion:
		var delta = _event.relative
		parent.rotate_y(-delta.x * parent.sense_horizontal * .0001)
		parent.camera_mount.rotate_x(-delta.y * parent.sense_vertical * .0001)
		parent.camera_mount.rotation.x = clamp(parent.camera_mount.rotation.x, deg_to_rad(-90), deg_to_rad(45))
	pass

## Called by the state machine on the engine's main loop tick.
func process_frame(_delta: float) -> void:
	pass
 
## Called by the state machine on the engine's physics update tick.
func process_physics(_delta: float) -> void:
	pass

## Called by the state machine upon changing the active state.
func enter(previous_state: MovementState, _data: Dictionary = {}) -> void:
	#print("Entering new state:\t", self.statename)
	pass

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	#print("Exiting state:\t", self.statename)
	pass


func get_movement_direction() -> Vector3:
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := parent.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	direction.y = 0
	var movement := direction.normalized()
	
	return movement

func accelerate(target_direction: Vector3, max_horizontal_speed: float, delta: float, control_factor: float) -> void:
	# Calcola la velocità orizzontale target basata sulla direzione input e velocità massima
	var target_horizontal_velocity = target_direction * max_horizontal_speed
	
	# Muovi la velocità corrente del player verso la velocità target orizzontale,
	# usando il 'control_factor' per definire quanto rapidamente.
	# Questo permette di mantenere lo slancio ma aggiungere controllo.
	parent.velocity.x = move_toward(parent.velocity.x, target_horizontal_velocity.x, delta * control_factor)
	parent.velocity.z = move_toward(parent.velocity.z, target_horizontal_velocity.z, delta * control_factor)

func apply_gravity(delta: float) -> void:
	if not parent.is_on_floor():
		parent.velocity.y -= gravity * delta
