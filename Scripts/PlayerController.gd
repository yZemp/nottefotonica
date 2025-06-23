extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SMOOTH_SPEED = 10.0
const AIR_MANOVRABILITY := 1.0
@export var sense_horizontal = .05
@export var sense_vertical = .05
@onready var camera_mount: Node3D = $CameraMount
@onready var camera_3d: Camera3D = $CameraMount/Camera3D
@onready var hand_mount: Node3D = $CameraMount/Camera3D/HandMount
@onready var game_weapon: Node3D = $CameraMount/Camera3D/HandMount/GameWeapon
@onready var movement_state_machine: MovementStateMachine = $MovementStateMachine
@onready var firing_state_machine: FiringStateMachine = $FiringStateMachine
@onready var hud: CanvasLayer = %Hud

@export var max_health: int = 100
@export var health: int

func _ready() -> void:
	health = max_health
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	movement_state_machine.init(self)
	firing_state_machine.init(self)

func _physics_process(delta: float) -> void:
	movement_state_machine.process_physics(delta)
	firing_state_machine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	movement_state_machine.process_input(event)
	firing_state_machine.process_input(event)

func _process(delta):
	movement_state_machine.process_frame(delta)
	firing_state_machine.process_frame(delta)
