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

func setup_weapon() -> void:
	if weapon_data == null:
		printerr("Weapon data not assigned!")
		return
		
	current_ammo = weapon_data.max_ammo
	mesh_root.add_child(weapon_data.viewmodel.instantiate())
	fire_cooldown.wait_time = weapon_data.fire_rate / 60
	reload_cooldown.wait_time = weapon_data.reload_time

func fire() -> void:
	can_fire = false
	current_ammo -= 1
	fire_cooldown.start()
	await fire_cooldown.timeout
	fired.emit()
	if current_ammo == 0:
		return
	can_fire = true

func get_ammo_status() -> String:
	return "%d / %d" % [current_ammo, weapon_data.max_ammo]
