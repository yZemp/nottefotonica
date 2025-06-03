## Virtual base class for all states.
## Extend this class and override its methods to implement a state.
extends Node
class_name FiringState

var statename: String = ""

## Emitted when the state finishes and wants to transition to another state.
signal finished(next_state_path: String, data: Dictionary)

@export var animation_name: String

var parent: CharacterBody3D

## Called by the state machine when receiving unhandled input events.
func process_input(_event: InputEvent) -> FiringState:
	return null

## Called by the state machine on the engine's main loop tick.
func process_frame(_delta: float) -> FiringState:
	return null
 
## Called by the state machine on the engine's physics update tick.
func process_physics(_delta: float) -> FiringState:
	return null

## Called by the state machine upon changing the active state.
func enter() -> void:
	print("Entering new state:\t", self.statename)
	pass

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	print("Exiting state:\t", self.statename)
	pass


func get_movement_direction() -> Vector3:
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := parent.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	direction.y = 0
	var movement := direction.normalized()
	
	return movement
