extends MovementState
class_name Fall

@export var idle_state: MovementState
@export var walk_state: MovementState

func enter(previous_state: MovementState, data: Dictionary = {}) -> void:
	statename = "Fall"
	super(previous_state, data)

func process_physics(delta: float) -> void:
	apply_gravity(delta)
	
	var movement = get_movement_direction()
	
	var air_speed : float = parent.SPEED * parent.AIR_SPEED_MOD
	if Input.is_action_pressed("sprint"):
		air_speed = parent.SPEED * parent.SPRINT_MOD * parent.AIR_SPEED_MOD
	
	parent.velocity.x += movement.x * parent.AIR_MANOVRABILITY * delta
	parent.velocity.z += movement.z * parent.AIR_MANOVRABILITY * delta	
	
	# Clamping the speed
	var current_horizontal_velocity_vec2 = Vector2(parent.velocity.x, parent.velocity.z)
	var current_horizontal_magnitude = current_horizontal_velocity_vec2.length()
	
	if current_horizontal_magnitude > air_speed:
		# Se la velocità attuale supera il massimo, normalizziamo il vettore e lo scaliamo al massimo consentito.
		var normalized_horizontal_velocity = current_horizontal_velocity_vec2.normalized()
		parent.velocity.x = normalized_horizontal_velocity.x * air_speed
		parent.velocity.z = normalized_horizontal_velocity.y * air_speed
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != Vector3.ZERO:
			finished.emit(walk_state)
		else:
			finished.emit(idle_state)
