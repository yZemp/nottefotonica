extends MovementState
class_name Walk

@export var idle_state: MovementState
@export var fall_state: MovementState
@export var jump_state: MovementState
@export var sprint_state: MovementState

func enter() -> void:
	statename = "Walk"
	super()

func process_input(event: InputEvent) -> MovementState:
	super(event)
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	return null
	
func process_physics(delta: float) -> MovementState:
	parent.velocity.y += gravity * delta
	
	var movement = get_movement_direction() * move_speed
	
	if movement == Vector3.ZERO:
		return idle_state
		
	parent.velocity.x = movement.x
	parent.velocity.z = movement.z
	parent.move_and_slide()
	
	if Input.is_action_pressed("sprint"):
		return sprint_state
	
	if !parent.is_on_floor():
		return fall_state
	return null
	
