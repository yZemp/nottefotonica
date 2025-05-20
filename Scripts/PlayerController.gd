extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SMOOTH_SPEED = 10.0
@export var sense_horizontal = .05
@export var sense_vertical = .05
@onready var camera_mount: Node3D = $CameraMount

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(- event.relative.x * sense_horizontal))
		camera_mount.rotate_x(deg_to_rad(- event.relative.y * sense_vertical))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# input_dir is a Vector2
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var visual_dir = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
