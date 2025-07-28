extends Node3D

var map: Node = null
@onready var wave_manager: Node = $WaveManager

func _ready() -> void:
	map = $MapContainer.get_child(0)
	if map and wave_manager:
		wave_manager.init(map)
		map.init(self, wave_manager)
	else:
		print("Error: Map or WaveManager not found.")
