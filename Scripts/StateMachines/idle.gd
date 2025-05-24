extends MovementState
class_name Idle

@export var fall_state: MovementState
@export var jump_state: MovementState
@export var walk_state: MovementState
@export var sprint_state: MovementState

func enter() -> void:
	statename = "Idle"
	super()
	parent.velocity.x = 0
	parent.velocity.z = 0

func process_input(event: InputEvent) -> MovementState:
	super(event)

	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	
	var movement = get_movement_direction()
	
	if movement != Vector3.ZERO:
		if Input.is_action_pressed("sprint"):
			return sprint_state
		return walk_state
	return null
	
func process_physics(delta: float) -> MovementState:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
	
