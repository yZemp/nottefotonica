extends Node

@onready var player_spawner: Marker3D = $PlayerSpawner
@onready var bbv2: CharacterBody3D = $BBv2

@export var player_scene: PackedScene
var spawned_player: Node = null

func init(player_parent: Node) -> void:
	spawn_player(player_parent)

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
