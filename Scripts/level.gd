extends Node

@onready var player_spawner: Marker3D = $PlayerSpawner

@export var player_scene: PackedScene
var spawned_player: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init() -> void:
	spawn_player()
	
	
func spawn_player():
	if spawned_player:
		spawned_player.queue_free()
		
	if player_scene: 
		spawned_player = player_scene.instantiate()
		
		# Aggiunge il player come figlio della scena corrente
		# In Godot 4, di solito si aggiunge alla scena corrente (get_tree().current_scene)
		# Se vuoi un nodo specifico come genitore, dovresti passarlo come parametro 
		# e usarlo qui al posto di get_tree().current_scene
		get_tree().current_scene.add_child(spawned_player)
		
		if spawned_player is Node3D:
			spawned_player.global_transform = player_spawner.global_transform
	else:
		print("Error: No scene found to be spawned")
