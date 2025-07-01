extends Node3D

var weapon_data: WeaponResource
@onready var mesh_root: Node3D = $meshRoot
@onready var fire_cooldown: Timer = $fire_cooldown
@onready var reload_cooldown: Timer = $reload_cooldown
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal fired
signal reloaded
signal out_of_ammo

# Internal state
var current_ammo: int
var can_fire: bool = true
var is_reloading: bool = false

func _ready() -> void:
	pass

func setup_weapon(new_weapon_data) -> void:
	if new_weapon_data == null:
		printerr("Weapon data not assigned!")
		return
	
	weapon_data = new_weapon_data
	#print("DEBUG: loaded fire_rate: ", weapon_data.fire_rate)
	
	current_ammo = weapon_data.max_ammo
	if mesh_root:
		for child in mesh_root.get_children():
			child.queue_free()
			
	# Adding new model and positioning it
	var new_model = weapon_data.viewmodel.instantiate()
	mesh_root.add_child(new_model)
	new_model.transform = new_weapon_data.transform
	
	fire_cooldown.wait_time = 60. / weapon_data.fire_rate
	#print("DEBUG: loaded fire_cooldown.wait_time: ", fire_cooldown.wait_time)
	reload_cooldown.wait_time = weapon_data.reload_time

func fire() -> void:
	#print("DEBUG: Try firing. can_fire: ", can_fire, " is_reloading: ", is_reloading)
	if is_reloading or not can_fire:
		return
	
	if current_ammo == 0:
		return
	
	can_fire = false
	current_ammo -= 1
	animation_player.play("Recoil")
	fired.emit(weapon_data)
	fire_cooldown.start()

func _on_fire_cooldown_timeout() -> void:
	#print("DEBUG: fire_cooldown timed out. can_fire set to TRUE.")
	can_fire = true

func get_ammo_status() -> String:
	return "%d / %d" % [current_ammo, weapon_data.max_ammo]
