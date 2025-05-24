extends MovementState
class_name Fall

@export var idle_state: MovementState
@export var walk_state: MovementState

func enter() -> void:
	statename = "Fall"
	super()

func process_physics(delta: float) -> MovementState:
	parent.velocity.y += gravity * delta
	
	var movement = get_movement_direction()
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != Vector3.ZERO:
			return walk_state
		return idle_state
	return null
