
extends Node

signal wave_completed(wave_id: String)
signal all_enemies_defeated(wave_id: String)

var map_ref: Node = null
var current_wave_data: Dictionary = {}

func init(map_node: Node) -> void:
	map_ref = map_node
	# Connect the _enemy_killed signal from Map_1
	map_ref.connect("_enemy_killed", Callable(self, "_on_enemy_killed"))
	
# Called by a Spawner when it starts spawning enemies for a wave
func register_wave_spawn(wave_id: String, enemies_to_spawn_count: int) -> void:
	if not current_wave_data.has(wave_id):
		current_wave_data[wave_id] = {
			"total_enemies": enemies_to_spawn_count,
			"defeated_enemies": 0
		}
		print("Registered wave '" + wave_id + "' with " + str(enemies_to_spawn_count) + " enemies.")
	else:
		# If a spawner triggers the same wave multiple times (e.g., multiple spawners for the same wave_id)
		printerr("Spawned wave with existing id")
		#current_wave_data[wave_id]["total_enemies"] += enemies_to_spawn_count
		#print("Updated wave '" + wave_id + "', total enemies: " + str(current_wave_data[wave_id]["total_enemies"]))


func _on_enemy_killed(wave_id: String) -> void:
	if current_wave_data.has(wave_id):
		current_wave_data[wave_id]["defeated_enemies"] += 1
		var remaining_enemies = current_wave_data[wave_id]["total_enemies"] - current_wave_data[wave_id]["defeated_enemies"]
		print("Enemy killed for wave '" + wave_id + "'. Remaining: " + str(remaining_enemies))
		
		if current_wave_data[wave_id]["defeated_enemies"] >= current_wave_data[wave_id]["total_enemies"]:
			print("Wave '" + wave_id + "' completed!")
			emit_signal("wave_completed", wave_id)
			emit_signal("all_enemies_defeated", wave_id)
			current_wave_data.erase(wave_id)
