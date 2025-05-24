extends MovementState
class_name Jump

@export var idle_state: MovementState
@export var fall_state: MovementState
@export var move_state: MovementState
@export var sprint_state: MovementState

@export var jump_force: float = 4.0

func enter() -> void:
	statename = "Jump"
	super()
	parent.velocity.y = jump_force

func process_physics(delta: float) -> MovementState:
	parent.velocity.y += gravity * delta
	
	var movement = get_movement_direction()
	parent.move_and_slide()
	
	if parent.velocity.y < 0:
		return fall_state
	
	if parent.is_on_floor():
		if movement == Vector3.ZERO:
			if Input.is_action_pressed("sprint"):
				return sprint_state
			return move_state
		return idle_state
	return null
	
