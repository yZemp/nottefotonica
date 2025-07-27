extends CanvasLayer

signal start_playing(lvl_indx : int)
@onready var play: Button = $PanelContainer/MarginContainer/VBoxContainer/Play

func init(main_game_node: Node) -> void:
	if !("on_start_playing" in main_game_node):
		printerr("No on_start_playing function found on main")
	start_playing.connect(main_game_node.on_start_playing)

func _on_play_pressed() -> void:
	# 1 == temp value for level 1
	start_playing.emit(1)

func _on_quit_pressed() -> void:
	print("Quitting")
	get_tree().quit()
