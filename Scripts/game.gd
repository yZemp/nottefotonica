extends Node3D

@export var playable_levels: Array[PackedScene]
@export var menus: Array[PackedScene]

@onready var active_level: Node = $ActiveLevel

var current_level: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_menu(menus[0])
	
func load_menu(menu_scene: PackedScene) -> void:
	if current_level:
		current_level.queue_free()
		current_level = null
		
	var menu_instance = menu_scene.instantiate()
	active_level.add_child(menu_instance)
	current_level = menu_instance
	
	# Connetti il segnale start_playing del menu
	if menu_instance.has_signal("start_playing"):
		menu_instance.start_playing.connect(on_start_playing)


func load_level(level_index: int) -> void:
	if level_index < 0 or level_index >= playable_levels.size():
		print("Errore: Indice del livello giocabile non valido.")
		return
	
	if current_level:
		current_level.queue_free()
		current_level = null
	
	var new_level_packed_scene = playable_levels[level_index]
	var new_level_instance = new_level_packed_scene.instantiate()
	active_level.add_child(new_level_instance)
	current_level = new_level_instance

func on_start_playing(lvl_indx: int) -> void:
	print("Loading level (by index): ", lvl_indx)
	load_level(lvl_indx)
