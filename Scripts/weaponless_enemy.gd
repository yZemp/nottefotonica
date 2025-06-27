extends CharacterBody3D

const SPEED = 1.5
const JUMP_VELOCITY = 4.5
const RANGE = 2.0

@export var target : CharacterBody3D = null

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Run")
	animation_player.get_animation("Run").loop_mode = (Animation.LOOP_LINEAR)
	
func _change_target(trgt : CharacterBody3D) -> void:
	target = trgt
	
func _process(delta: float) -> void:
	velocity = Vector3.ZERO
	nav_agent.set_target_position(target.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
	#look_at(Vector3(target.global_position.x, target.global_position.y, target.global_position.z), Vector3.UP)
	
	move_and_slide()
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity -= get_gravity() * delta
	
	move_and_slide()
	
	
func _is_target_in_range():
	return global_position.distance_to(target.global_position) < RANGE
