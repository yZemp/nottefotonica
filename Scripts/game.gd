extends Node3D

@export var playable_levels: Array[PackedScene]
@export var main_menu: PackedScene
@onready var pause_menu: CanvasLayer = $PauseMenu

@onready var level_container: Node = $LevelContainer
var current_level: Node = null

var fullscreen : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.hide()
	load_main_menu()
	fullscreen = true
	set_fullscreen(fullscreen)
	
	pause_menu.back_to_menu.connect(load_main_menu)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause_menu.pause()
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		fullscreen = !fullscreen
		set_fullscreen(fullscreen)

func load_main_menu() -> void:
	print("Loading menu")
	
	if current_level:
		current_level.queue_free()
		current_level = null
		
	var menu_instance = main_menu.instantiate()
	level_container.add_child(menu_instance)
	current_level = menu_instance
	
	# Connetti il segnale start_playing del menu
	if menu_instance.has_signal("start_playing"):
		menu_instance.start_playing.connect(on_start_playing)
	
func load_level(level_index: int) -> void:
	if level_index < 0 or level_index >= playable_levels.size():
		printerr("Level not found")
		return
	
	if current_level:
		current_level.queue_free()
		current_level = null
	
	current_level = playable_levels[level_index].instantiate()
	level_container.add_child(current_level)
	current_level.init(current_level)

func on_start_playing(lvl_indx: int) -> void:
	print("Loading level (by index): ", lvl_indx)
	load_level(lvl_indx)
	
func set_fullscreen(condition: bool):
	if condition:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
