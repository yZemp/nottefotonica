extends MovementState
class_name Fall

@export var idle_state: MovementState
@export var walk_state: MovementState

func enter(data: Dictionary = {}) -> void:
	statename = "Fall"
	super()

func process_physics(delta: float) -> void:
	parent.velocity.y += gravity * delta
	
	var movement = get_movement_direction()
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != Vector3.ZERO:
			finished.emit(walk_state)
		finished.emit(idle_state)
