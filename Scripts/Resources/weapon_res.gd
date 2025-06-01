extends Resource
class_name Weapon_res

signal fired
signal reloaded
signal out_of_ammo

@export var max_ammo: int
@export var fire_rate: int
@export var reload_time: float
@export var scene: PackedScene
@export var base_dmg: int
@export var spread: int
@export var auto: bool

# Internal state
var current_ammo: int
var can_fire: bool = true
var is_reloading: bool = false

func init() -> void:
	current_ammo = max_ammo

func fire(parent: CharacterBody3D) -> void:
	if not can_fire or is_reloading:
		print("Cannot fire (already firing/reloading)")
		return
	
	if current_ammo <= 0:
		print("Cannot fire (out of ammo)")
		emit_signal("out_of_ammo")
		return
	
	print("Firing")
	
	current_ammo -= 1
	can_fire = false
	emit_signal("fired")

	# Timer per ritardo tra i colpi
	await parent.get_tree().create_timer(fire_rate / 60).timeout
	can_fire = true

func reload(parent: CharacterBody3D) -> void:
	if is_reloading or current_ammo == max_ammo:
		return
	
	is_reloading = true
	can_fire = false
	
	await parent.get_tree().create_timer(reload_time).timeout
	current_ammo = max_ammo
	is_reloading = false
	can_fire = true
	emit_signal("reloaded")

func get_ammo_status() -> String:
	return "%d / %d" % [current_ammo, max_ammo]
