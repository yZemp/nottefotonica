extends CanvasLayer

signal back_to_menu()

func _ready() -> void:
	pass

func pause()-> void:
	get_tree().paused = true
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_go_home_pressed() -> void:
	get_tree().paused = false
	visible = false
	back_to_menu.emit()
