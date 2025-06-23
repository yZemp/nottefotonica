extends Node3D

var weapon_data: Weapon_resource
@onready var mesh_root: Node3D = $meshRoot
@onready var fire_cooldown: Timer = $fire_cooldown
@onready var reload_cooldown: Timer = $reload_cooldown

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
	print("DEBUG: fire_rate caricato: ", weapon_data.fire_rate)
	
	current_ammo = weapon_data.max_ammo
	if mesh_root:
		for child in mesh_root.get_children():
			child.queue_free()
	mesh_root.add_child(weapon_data.viewmodel.instantiate())
	fire_cooldown.wait_time = 60. / weapon_data.fire_rate
	print("DEBUG: fire_cooldown.wait_time calcolato: ", fire_cooldown.wait_time)
	reload_cooldown.wait_time = weapon_data.reload_time

func fire() -> void:
	print("DEBUG: Tentativo di sparo. can_fire:", can_fire, " is_reloading:", is_reloading)
	if is_reloading or not can_fire:
		return
	
	if current_ammo == 0:
		return
	
	can_fire = false
	current_ammo -= 1
	fired.emit()
	fire_cooldown.start()

func _on_fire_cooldown_timeout() -> void:
	print("DEBUG: fire_cooldown scaduto. can_fire impostato a TRUE.")
	can_fire = true

func get_ammo_status() -> String:
	return "%d / %d" % [current_ammo, weapon_data.max_ammo]
