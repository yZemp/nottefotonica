extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SMOOTH_SPEED = 10.0
@export var sense_horizontal = .05
@export var sense_vertical = .05
@onready var camera_mount: Node3D = $CameraMount
@onready var camera_3d: Camera3D = $CameraMount/Camera3D
@onready var hand_mount: Node3D = $CameraMount/Camera3D/HandMount
@onready var movement_state_machine: Node = $MovementStateMachine

var scrausa = preload("res://Scenes/Guns/scrausa.tscn")
var p69 = preload("res://Scenes/Guns/p69.tscn")
var assault = preload("res://Scenes/Guns/assault.tscn")
var losgravo = preload("res://Scenes/Guns/losgravo.tscn")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	movement_state_machine.init(self)

func _physics_process(delta: float) -> void:
	movement_state_machine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	movement_state_machine.process_input(event)

func _process(delta):
	movement_state_machine.process_frame(delta)
	
	if Input.is_action_just_pressed("slot1"):
		change_gun(scrausa.instantiate())
	if Input.is_action_just_pressed("slot2"):
		change_gun(p69.instantiate())
	if Input.is_action_just_pressed("slot3"):
		change_gun(assault.instantiate())
	if Input.is_action_just_pressed("slot4"):
		change_gun(losgravo.instantiate())

func change_gun(new_gun: Node3D):
	if hand_mount.get_child_count() > 0:
		hand_mount.get_child(0).queue_free()
	new_gun.transform = Transform3D.IDENTITY
	hand_mount.add_child(new_gun)
