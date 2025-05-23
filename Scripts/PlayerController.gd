extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SMOOTH_SPEED = 10.0
@export var sense_horizontal = .05
@export var sense_vertical = .05
@onready var camera_mount: Node3D = $CameraMount
@onready var camera_3d: Camera3D = $CameraMount/Camera3D
@onready var hand_mount: Node3D = $CameraMount/Camera3D/HandMount

var scrausa = preload("res://Scenes/Guns/scrausa.tscn")
var p69 = preload("res://Scenes/Guns/p69.tscn")
var assault = preload("res://Scenes/Guns/assault.tscn")
var losgravo = preload("res://Scenes/Guns/losgravo.tscn")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(- event.relative.x * sense_horizontal))
		
		#Rotate camera
		camera_3d.rotate_x(deg_to_rad(- event.relative.y * sense_vertical))
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-90), deg_to_rad(40))

func _process(delta):
	if Input.is_action_just_pressed("slot1"):
		change_gun(scrausa.instantiate())
	if Input.is_action_just_pressed("slot2"):
		change_gun(p69.instantiate())
	if Input.is_action_just_pressed("slot3"):
		change_gun(assault.instantiate())
	if Input.is_action_just_pressed("slot4"):
		change_gun(losgravo.instantiate())

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

func change_gun(new_gun: Node3D):
	if hand_mount.get_child_count() > 0:
		hand_mount.get_child(0).queue_free()
	new_gun.transform = Transform3D.IDENTITY
	hand_mount.add_child(new_gun)
