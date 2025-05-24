## Virtual base class for all states.
## Extend this class and override its methods to implement a state.
extends Node
class_name MovementState

var statename: String = ""

## Emitted when the state finishes and wants to transition to another state.
signal finished(next_state_path: String, data: Dictionary)

@export var animation_name: String
@export var move_speed: float = 2.0
@export var run_speed_modifier: float = 2.5

var gravity: int = - ProjectSettings.get_setting("physics/3d/default_gravity")
var parent: CharacterBody3D

## Called by the state machine when receiving unhandled input events.
func process_input(_event: InputEvent) -> MovementState:
	#Rotating parent and camera
	if _event is InputEventMouseMotion:
		var delta = _event.relative
		parent.rotate_y(-delta.x * parent.sense_horizontal)
		parent.camera_mount.rotate_x(-delta.y * parent.sense_vertical)
		parent.camera_mount.rotation.x = clamp(parent.camera_mount.rotation.x, deg_to_rad(-90), deg_to_rad(40))
	return null

## Called by the state machine on the engine's main loop tick.
func process_frame(_delta: float) -> MovementState:
	return null
 
## Called by the state machine on the engine's physics update tick.
func process_physics(_delta: float) -> MovementState:
	return null

## Called by the state machine upon changing the active state.
func enter() -> void:
	print("Entering new state:\t", self.statename)

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	print("Exiting state:\t", self.statename)



func get_movement_direction() -> Vector3:
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := parent.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	direction.y = 0
	var movement := direction.normalized()
	
	return movement
