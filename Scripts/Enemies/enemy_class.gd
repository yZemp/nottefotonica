extends CharacterBody3D
class_name Enemy

@export var WALK_SPEED : float
@export var MAX_HEALTH : float
@export var BASE_DMG : float

var health : float
var alive := true

var target : CharacterBody3D = null

@export var nav_agent: NavigationAgent3D
@export var animation_player: AnimationPlayer
@export var skeleton_3d: Skeleton3D

func _ready() -> void:
	health = MAX_HEALTH
	
func _change_target(trgt : CharacterBody3D) -> void:
	target = trgt
	
func _process(delta: float) -> void:
	if not alive:
		return
	
func _physics_process(delta: float) -> void:
	if not target:
		#printerr("Target not set!")
		return
		
	if not is_on_floor():
		velocity.y += ProjectSettings.get_setting("physics/3d/default_gravity") * delta
	else:
		if not alive:
			return
	move_and_slide()

func _face_player(delta: float, look_direction: Vector3 = Vector3.ZERO) -> void:
	var target_direction = Vector3.ZERO
	 
	if look_direction.length_squared() > 0.01:
		target_direction = look_direction
	elif target:
		target_direction = (target.global_transform.origin - global_transform.origin).normalized()
	else:
		return
		
	rotation.y = lerp_angle(rotation.y, atan2(-target_direction.x, -target_direction.z), delta * 10.0)

func _take_dmg(dmg: float) -> void:
	health -= dmg
	
	if health <= 0.0:
		die()

func die():
	queue_free()
