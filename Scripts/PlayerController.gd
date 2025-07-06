extends CharacterBody3D

const SPEED = 2.0
const SPRINT_MOD = 1.3
const JUMP_VELOCITY = 4.5
const SMOOTH_SPEED = 50.0
const AIR_MANOVRABILITY := 20.0
const AIR_STRAFE := 2.

# TODO: Move this
const HEADSHOT_MOD := 2.5

@export var sense_horizontal : float = 10.
@export var sense_vertical : float = 10.
@onready var camera_mount: Node3D = $CameraMount
@onready var camera_3d: Camera3D = $CameraMount/Camera3D
@onready var hand_mount: Node3D = $CameraMount/Camera3D/HandMount
@onready var game_weapon: Node3D = $CameraMount/Camera3D/HandMount/GameWeapon
@onready var aim_cast: RayCast3D = $CameraMount/Camera3D/AimCast
@onready var movement_state_machine: MovementStateMachine = $MovementStateMachine
@onready var firing_state_machine: FiringStateMachine = $FiringStateMachine
@onready var hud: CanvasLayer = $Hud

@export var player_weapon_inventory: Array[WeaponResource] = []
var current_weapon_index: int = -1

@export var max_health: int = 100
@export var health: int

func _ready() -> void:
	health = max_health
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera_3d.current = true
	movement_state_machine.init(self)
	firing_state_machine.init(self)
	game_weapon.fired.connect(_shoot)
	
	if player_weapon_inventory.size() > 0:
		change_weapon(0)
	else:
		printerr("No weapon during init!")

func _physics_process(delta: float) -> void:
	movement_state_machine.process_physics(delta)
	firing_state_machine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("slot1"):
		change_weapon(0)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("slot2"):
		change_weapon(1)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("slot3"):
		change_weapon(2)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("slot4"):
		change_weapon(3)
		get_viewport().set_input_as_handled()
	
	if event.is_action_pressed("Reload") and game_weapon.current_ammo != game_weapon.weapon_data.max_ammo:
		firing_state_machine.request_weapon_reload_state()
	
	movement_state_machine.process_input(event)
	firing_state_machine.process_input(event)

func _process(delta):
	if health <= 0:
		die()
	
	movement_state_machine.process_frame(delta)
	firing_state_machine.process_frame(delta)

func change_weapon(index: int) -> void:
	if player_weapon_inventory.is_empty():
		# TODO: Implement this thing
		printerr("No weapon available")
		return
		
	if index < 0 or index >= player_weapon_inventory.size():
		# TODO: Implement this thing
		printerr("Invalid index (for player inventory): ", index)
		return
		
	var new_weapon_resource = player_weapon_inventory[index]
	if new_weapon_resource == null:
		printerr("Invalid weapon resource at index: ", index)
		return

	if current_weapon_index != index:
		print("Changing weapon from index ", index, " (", new_weapon_resource.name, ")")
		current_weapon_index = index
		firing_state_machine.request_weapon_switch_state(new_weapon_resource)
	else:
		print("Weapon already selected (", new_weapon_resource.name, ").")

func _shoot(weapon: WeaponResource) -> void:
	if aim_cast.is_colliding():
		var bone = aim_cast.get_collider()
		
		if not bone is PhysicalBone3D:
			printerr("Did not shoot a bone. Object shot is:\n", bone, bone.get_class())
		
		var dmg = weapon.base_dmg
		
		if bone.name == "Physical Bone mixamorig1_Head":
			dmg = weapon.base_dmg * HEADSHOT_MOD
		
		var shot_enemy = _get_enemy_from_bone(bone)
		if not shot_enemy is CharacterBody3D:
			printerr("Error in finding target")
		else:
			shot_enemy._take_dmg(dmg)

func take_damage(dmg) -> void:
	health -= dmg
	hud.damage_graphics()
	
func die() -> void:
	#print("EHHEHEHE dead")
	pass

func _on_gui_update_timeout() -> void:
	for child in hud.get_children():
		if child is BoxContainer and child.name == "Ammo":
			child.get_children()[0].text = game_weapon.get_ammo_status()
			
		if child is BoxContainer and child.name == "Health":
			child.get_children()[0].text = "%d / %d" % [health, max_health]
	
	
func _get_enemy_from_bone(bone: PhysicalBone3D):
	var enemy_nodes = get_tree().get_nodes_in_group("Enemies")
	
	# Going up in hierarchy until in Enemies
	var current_node = bone
	while current_node != null:
		if current_node in enemy_nodes:
			return current_node
		current_node = current_node.get_parent()
	return null
