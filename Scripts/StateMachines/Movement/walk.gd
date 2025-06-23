extends MovementState
class_name Walk

@export var idle_state: MovementState
@export var fall_state: MovementState
@export var jump_state: MovementState
@export var sprint_state: MovementState

func enter(previous_state: MovementState, data: Dictionary = {}) -> void:
	statename = "Walk"
	super(previous_state, data)

func process_input(event: InputEvent) -> void:
	super(event)
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		finished.emit(jump_state)
	
func process_physics(delta: float) -> void:
	parent.velocity.y += gravity * delta
	
	var movement = get_movement_direction() * move_speed
	
	if movement == Vector3.ZERO:
		finished.emit(idle_state)
	
	accelerate(movement, delta)
	parent.move_and_slide()
	
	if Input.is_action_pressed("sprint"):
		finished.emit(sprint_state)
	
	if !parent.is_on_floor():
		finished.emit(fall_state)
