extends CanvasLayer

signal start_playing(lvl_indx : int)

func _on_play_pressed() -> void:
	start_playing.emit(0)

func _on_quit_pressed() -> void:
	print("Quitting")
	get_tree().quit()
