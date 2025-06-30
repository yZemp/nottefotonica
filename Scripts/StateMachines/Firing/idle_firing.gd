extends FiringState
class_name Idle_firing

@export var firing: FiringState
@export var auto_firing: FiringState
@export var reloading: FiringState
@export var switching: FiringState

func enter(previous_state: FiringState, data: Dictionary = {}) -> void:
	statename = "Idle"
	super(previous_state, data)

func process_input(event: InputEvent) -> void:
	super(event)

	if Input.is_action_just_pressed("primary_fire") and parent.game_weapon.can_fire:
		if parent.game_weapon.weapon_data.auto:
			finished.emit(auto_firing)
		else:
			finished.emit(firing)
