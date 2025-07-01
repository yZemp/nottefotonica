extends Node

@onready var player_spawner: Marker3D = $PlayerSpawner
@onready var bbv2: CharacterBody3D = $BBv2
@onready var trigger_and_spawner: Node3D = $TriggerAndSpawner

@export var player_scene: PackedScene
var spawned_player: Node = null
@export var basic_enemy: PackedScene

func init(player_parent: Node) -> void:
	spawn_player(player_parent)
	trigger_and_spawner.triggered_spawner.connect(_on_spawner_triggered)

func spawn_player(player_parent: Node) -> void:
	if spawned_player:
		spawned_player.queue_free()
		
	if player_scene: 
		spawned_player = player_scene.instantiate()
		bbv2._change_target(spawned_player)
		
		# Aggiunge il player come figlio della scena corrente
		# In Godot 4, di solito si aggiunge alla scena corrente (get_tree().current_scene)
		# Se vuoi un nodo specifico come genitore, dovresti passarlo come parametro 
		# e usarlo qui al posto di get_tree().current_scene
		#get_tree().current_scene.add_child(spawned_player)
		player_parent.add_child(spawned_player)
		
		if spawned_player is Node3D:
			spawned_player.global_transform = player_spawner.global_transform
	else:
		print("Error: No scene found to be spawned")

func _on_spawner_triggered(area: Area3D) -> void:
	spawn_enemies(basic_enemy, area, spawned_player, 20)

func spawn_enemies(enemy_scene: PackedScene, area: Area3D, spawned_player: CharacterBody3D, N: int = 1):
	'''
	Spawn N instanciations of enemy randomly inside area3D
	''' 
	
	# Get CollisionShape3D of the area
	var collision_shape = null
	for child in area.get_children():
		if child is CollisionShape3D:
			collision_shape = child
			break

	if not collision_shape:
		printerr("Error: Area3D has no collision shape")
		return

	var extents = Vector3(0, 0, 0)
	if collision_shape.shape is BoxShape3D:
		extents = collision_shape.shape.extents
	elif collision_shape.shape is SphereShape3D:
		extents = Vector3(collision_shape.shape.radius, collision_shape.shape.radius, collision_shape.shape.radius)
	else:
		printerr("Error: unrecognized shape of the spawner")
		return

	var area_global_transform = area.global_transform

	for i in range(N):
		var new_enemy = enemy_scene.instantiate()

		# Generating random position
		var random_x = randf_range(-extents.x, extents.x)
		var random_y = randf_range(-extents.y, extents.y)
		var random_z = randf_range(-extents.z, extents.z)
		var random_position_local = Vector3(random_x, random_y, random_z)

		var random_position_global = area_global_transform * random_position_local
		
		new_enemy.global_position = random_position_global
		new_enemy._change_target(spawned_player)
		get_tree().current_scene.add_child(new_enemy)
		print("Spawned enemy at:", new_enemy.global_position)
