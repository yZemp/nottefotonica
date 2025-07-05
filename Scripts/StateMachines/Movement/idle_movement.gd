extends MovementState
class_name Idle_movement

@export var fall_state: MovementState
@export var jump_state: MovementState
@export var walk_state: MovementState
@export var sprint_state: MovementState

func enter(previous_state: MovementState, data: Dictionary = {}) -> void:
	statename = "Idle"
	super(previous_state, data)
	#parent.velocity.x = 0
	#parent.velocity.z = 0

func process_input(event: InputEvent) -> void:
	super(event)

	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		finished.emit(jump_state)
	
	var movement = get_movement_direction()
	
	if movement != Vector3.ZERO:
		if Input.is_action_pressed("sprint"):
			finished.emit(sprint_state)
		else:
			finished.emit(walk_state)

func process_physics(delta: float) -> void:
	apply_gravity(delta)
	
	accelerate(Vector3.ZERO, parent.SPEED, delta, parent.SMOOTH_SPEED)
	
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		finished.emit(fall_state)
	
