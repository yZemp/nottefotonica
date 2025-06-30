extends CharacterBody3D

const SPEED := 2.5
const RANGE := 2.0
const RANGE_HIT_MOD := 1.2
const DMG := 8.
const MAX_HEALTH := 50.
var health : float
var can_punch := true
var alive := true

var target : CharacterBody3D = null

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var despawn_timer: Timer = $DespawnTimer
@onready var skeleton_3d: Skeleton3D = $Armature/Skeleton3D

func _ready() -> void:
	health = MAX_HEALTH
	
func _change_target(trgt : CharacterBody3D) -> void:
	target = trgt
	
func _process(delta: float) -> void:
	if not alive:
		return
		
	if can_punch:
		animation_player.play("Run")
		animation_player.get_animation("Run").loop_mode = (Animation.LOOP_LINEAR)
	
func _physics_process(delta: float) -> void:
		
	if not target:
		printerr("Target not set!")
		return
		
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	else:
		if not alive:
			return
			
		if can_punch:
			nav_agent.set_target_position(target.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			_face_player(delta)
		else:
			velocity.x = 0.0
			velocity.z = 0.0
			_face_player(delta, (target.global_transform.origin - global_transform.origin).normalized())
		
	if _is_target_in_range() and can_punch:
		velocity = Vector3.ZERO
		punch()
			
	move_and_slide()
	#
	#
func _is_target_in_range():

	return global_position.distance_to(target.global_position) < RANGE

func _face_player(delta: float, look_direction: Vector3 = Vector3.ZERO) -> void:
	var target_direction = Vector3.ZERO
	 
	if look_direction.length_squared() > 0.01:
		target_direction = look_direction
	elif target:
		target_direction = (target.global_transform.origin - global_transform.origin).normalized()
	else:
		return
		
	rotation.y = lerp_angle(rotation.y, atan2(-target_direction.x, -target_direction.z), delta * 10.0)

func punch() -> void:
	can_punch = false
	animation_player.play("Punch")

func _hit_damage() -> void:
	if global_position.distance_to(target.global_position) > RANGE * RANGE_HIT_MOD:
		return
	target.take_damage(DMG)

func _take_dmg(dmg: float) -> void:
	health -= dmg
	
	if health <= 0.0:
		die()

func _hit_finished() -> void:
	can_punch = true
	
func die():
	queue_free()
