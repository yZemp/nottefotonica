extends Node
class_name Spawner

signal triggered(wave_id: String, enemies_count: int)

@export var wave_id: String = "wave_id"
@export var enemy_scene: PackedScene

@onready var spawns: Node3D = $Spawns
@onready var trigger_area: Area3D = $Trigger

var triggerable : bool = true
var target : CharacterBody3D = null
var map_ref : Node = null


func _ready() -> void:
	if trigger_area:
		trigger_area.body_entered.connect(Callable(self, "_on_trigger_area_body_entered"))
	spawns.visible = false


func init(targ: CharacterBody3D, map: Node):
	target = targ
	map_ref = map


func _on_trigger_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and triggerable:
		emit_signal("triggered", wave_id, spawns.get_child_count())
		set_triggerable(false)
		spawn_enemies()


func spawn_enemies() -> void:
	if not enemy_scene:
		print("Warning: No enemy scene configured for this spawner (" + wave_id + ").")
		return
		
	print("Spawner '" + wave_id + "' triggered: Spawning " + str(spawns.get_child_count()) + " enemies...")
	var spawn_points = spawns.get_children()
	if spawn_points.is_empty():
		print("Warning: No spawn points available in this spawner (" + wave_id + ").")
		return
		
	var enemies_spawned_count = 0
	for child in spawns.get_children():
		# Pass the wave ID to the map's spawn method
		map_ref._spawn_enemy(child.global_transform, enemy_scene, wave_id)
		enemies_spawned_count += 1
	
	#print("Spawned " + str(enemies_spawned_count) + " enemies from spawner '" + wave_id + "'.")


func set_triggerable(value: bool) -> void:
	triggerable = value
	if trigger_area:
		# Use set_deferred to avoid issues modifying monitoring during a physics_process
		trigger_area.set_deferred("monitoring", value)
