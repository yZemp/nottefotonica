extends MovementState
class_name Jump

@export var idle_state: MovementState
@export var fall_state: MovementState
@export var move_state: MovementState
@export var sprint_state: MovementState

@export var jump_force: float = 4.0

func enter(previous_state: MovementState, data: Dictionary = {}) -> void:
	statename = "Jump"
	super(previous_state, data)
	parent.velocity.y = jump_force

func process_physics(delta: float) -> void:
	parent.velocity.y += gravity * delta
	
	var movement = get_movement_direction()
	
	accelerate(movement, delta)
	parent.move_and_slide()
	
	if parent.velocity.y < 0:
		finished.emit(fall_state)
		return
	
	if parent.is_on_floor():
		if movement != Vector3.ZERO:
			if Input.is_action_pressed("sprint"):
				finished.emit(sprint_state)
			else:
				finished.emit(move_state)
		else:
			finished.emit(idle_state)
