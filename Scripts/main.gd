extends Node3D

@export var playable_levels: Array[PackedScene]
@export var main_menu: PackedScene
@export var loading_screen: PackedScene
@onready var pause_menu: CanvasLayer = $PauseMenu

@onready var level_container: Node = $LevelContainer
var current_level: Node = null

@export var fullscreen : bool = true

func _ready() -> void:
	'''
	Init main game object:
		-Hide pause menu
		-Connect signals from pause menu
		-Set fullscreen (on by def)
		-Load main menu level
	'''
	pause_menu.hide()
	pause_menu.back_to_menu.connect(load_level.bind(0))
	set_fullscreen(fullscreen)
	load_level(0)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause_menu.pause()
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		fullscreen = !fullscreen
		set_fullscreen(fullscreen)


func load_level(level_index: int) -> void:
	if level_index < 0 or level_index >= playable_levels.size():
		printerr("Level not found")
		return
	
	if current_level:
		current_level.queue_free()
		current_level = null
	
	var loading_screen_instance = loading_screen.instantiate()
	level_container.add_child(loading_screen_instance)
	
	loading_screen_instance.start_loading_level(playable_levels[level_index])
	if loading_screen_instance.has_signal("level_loaded"):
		loading_screen_instance.level_loaded.connect(on_level_loaded)


func on_level_loaded(loaded_level: Node) -> void:
	print("Level loaded and ready!")
	current_level = loaded_level
	if "init" in current_level:
		current_level.init(self)


func on_start_playing(lvl_indx: int) -> void:
	print("Loading level (by index): ", lvl_indx)
	load_level(lvl_indx)


func set_fullscreen(condition: bool):
	if condition:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
