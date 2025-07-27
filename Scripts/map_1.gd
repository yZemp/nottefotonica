extends Node

signal _enemy_killed(wave_id: String)

@onready var player_spawner: Marker3D = $PlayerSpawner
@onready var spawner_container: Node = $SpawnerContainer
@onready var separator: StaticBody3D = $Separator
@onready var gate: Node3D = $Gate

@export var player_scene: PackedScene
var spawned_player: Node = null
var wave_manager_ref: Node = null # Reference to the WaveManager

func init(player_parent: Node, wave_manager: Node) -> void:
	spawn_player(player_parent)
	wave_manager_ref = wave_manager
	
	# Initialize all spawners present in the map
	if spawner_container:
		for child in spawner_container.get_children():
			if child is Spawner:
				child.init(spawned_player, self)
				# Connect the Spawner's triggered signal to the WaveManager
				child.connect("triggered", Callable(wave_manager_ref, "register_wave_spawn"))
	
	# Connect the wave completion signal from the WaveManager
	if wave_manager_ref:
		wave_manager_ref.connect("all_enemies_defeated", Callable(self, "_on_all_enemies_defeated"))


func spawn_player(player_parent: Node) -> void:
	if spawned_player:
		spawned_player.queue_free()
		
	if player_scene:
		spawned_player = player_scene.instantiate()
		player_parent.add_child(spawned_player)
		
		if spawned_player is Node3D:
			spawned_player.global_transform = player_spawner.global_transform
	else:
		print("Error: No player scene found to be spawned.")


func _spawn_enemy(spawn_location: Transform3D, enemy_scene: PackedScene, wave_id_for_enemy: String) -> void:
	'''
	Spawn one instance of a specific enemy at a specified position
	'''
	var new_enemy = enemy_scene.instantiate()
	# Connect on enemy killed function with the correct wave id
	new_enemy.connect("killed", Callable(self, "_on_enemy_killed_internal").bind(wave_id_for_enemy))
	new_enemy._change_target(spawned_player)
	add_child(new_enemy)
	new_enemy.global_transform = spawn_location
	#print("Enemy spawned for wave: " + wave_id_for_enemy)


# This method is called by the enemy's 'killed' signal, including the wave_id
func _on_enemy_killed_internal(wave_id: String) -> void:
	emit_signal("_enemy_killed", wave_id) # Emit the signal for the WaveManager with the wave ID


func _on_all_enemies_defeated(wave_id: String) -> void:
	print("All enemies for wave '" + wave_id + "' have been killed. Ending wave.")
	# Here you can activate map effects based on the wave ID
	# For example, if wave_id is "wave_1_east_gate"
	if wave_id == "wave_1": # Example: handle gate opening for a specific wave
		open_gate()
	# else if wave_id == "another_wave":
	#     open_another_gate()


func open_gate() -> void:
	separator.queue_free()
	gate.get_node("AnimationPlayer").play("Open")
