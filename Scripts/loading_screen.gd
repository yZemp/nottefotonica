extends CanvasLayer

signal level_loaded(loaded_level_instance: Node)

var progress : Array = []
var scene_status
var loaded_level_instance
var level_to_load_packed_scene

@onready var percentage_label: Label = $Panel/VBoxContainer/Percentage
@export var level_path : String = "res://Scenes/Level_1.tscn"

func start_loading_level(level_packed_scene: PackedScene) -> void:
	progress = []
	loaded_level_instance = null
	percentage_label.text = "0%"
	
	level_to_load_packed_scene = level_packed_scene
	
	ResourceLoader.load_threaded_request(level_to_load_packed_scene.resource_path)
	
	
func _process(_delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(level_to_load_packed_scene.resource_path, progress)
	
	percentage_label.text = str(floor(progress[0] * 100)) + "%"
	
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		if loaded_level_instance == null:
			loaded_level_instance = ResourceLoader.load_threaded_get(level_to_load_packed_scene.resource_path).instantiate()
			get_parent().add_child(loaded_level_instance)
			
			level_loaded.emit(loaded_level_instance)
			queue_free()
	elif status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		pass
	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		printerr("Failed to load level: ", level_to_load_packed_scene.resource_path)
		queue_free()
