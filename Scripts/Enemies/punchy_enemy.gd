extends Enemy
class_name PunchyEnemy

var can_hit := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Overwritten entirely
	#print("Processing: ", alive, "\n", enemy_data.TARGETING_DISTANCE)
	
	if not alive:
		return
	
	if can_hit and global_position.distance_to(target.global_position) < enemy_data.TARGETING_DISTANCE:
		animation_player.play("Run")
		animation_player.get_animation("Run").loop_mode = (Animation.LOOP_LINEAR)

func _physics_process(delta: float) -> void:
	
	super(delta)
	
	if is_on_floor():
		if can_hit and global_position.distance_to(target.global_position) < enemy_data.TARGETING_DISTANCE:
			nav_agent.set_target_position(target.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * enemy_data.WALK_SPEED
			_face_player(delta)
		else:
			velocity.x = 0.0
			velocity.z = 0.0
			_face_player(delta, (target.global_transform.origin - global_transform.origin).normalized())
	
	if _is_target_in_range() and can_hit:
		velocity = Vector3.ZERO
		punch()
			
	move_and_slide()
	

func _deal_damage() -> void:
	if global_position.distance_to(target.global_position) > enemy_data.RANGE * enemy_data.RANGE_HIT_MOD:
		return
	target.take_damage(enemy_data.BASE_DMG)

func _is_target_in_range():
	return global_position.distance_to(target.global_position) < enemy_data.RANGE

func punch() -> void:
	can_hit = false
	animation_player.play("Punch")
	
func _hit_finished() -> void:
	can_hit = true
