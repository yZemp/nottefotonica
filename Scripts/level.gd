extends Node

@onready var player_spawner: Marker3D = $PlayerSpawner
@onready var trigger_and_spawner: Node3D = $TriggerAndSpawner
@onready var separator: StaticBody3D = $Separator
@onready var gate: Node3D = $Gate
var counter : int = 0

@export var player_scene: PackedScene
var spawned_player: Node = null

func init(player_parent: Node) -> void:
	spawn_player(player_parent)
	trigger_and_spawner.spawn_enemy.connect(_spawn_enemy)

func spawn_player(player_parent: Node) -> void:
	if spawned_player:
		spawned_player.queue_free()
		
	if player_scene: 
		spawned_player = player_scene.instantiate()
		player_parent.add_child(spawned_player)
		
		if spawned_player is Node3D:
			spawned_player.global_transform = player_spawner.global_transform
	else:
		print("Error: No scene found to be spawned")

func _spawn_enemy(spawn_location: Node3D, enemy_scene: PackedScene) -> void:
	'''
	Spawn one instance of a specific enemy at a specified position
	''' 

	var new_enemy = enemy_scene.instantiate()
	new_enemy.killed.connect(open_gate)
	new_enemy._change_target(spawned_player)
	add_child(new_enemy)
	new_enemy.global_transform = spawn_location.global_transform
	#print("Spawned enemy with data:", new_enemy.enemy_data)

func open_gate() -> void:
	counter += 1
	if counter == 14:
		separator.queue_free()
		gate.get_node("AnimationPlayer").play("Open")
