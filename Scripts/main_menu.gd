extends CanvasLayer

signal start_playing(lvl_indx : int)

func _on_play_pressed() -> void:
	play()

func _on_quit_pressed() -> void:
	quit()


func play() -> void:
	start_playing.emit(0)
	
func quit() -> void:
	get_tree().quit()
