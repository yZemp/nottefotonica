extends FiringState
class_name Switching

@export var idle_firing: FiringState
@export var firing: FiringState
@export var reloading: FiringState
@export var auto_firing: FiringState

func enter(previous_state: FiringState, data: Dictionary = {}) -> void:
	statename = "Switching"
	super(previous_state, data)
	
	change_weapon(data["new_gun"])

func change_weapon(new_gun: Weapon_resource):
	parent.game_weapon.setup_weapon(new_gun)

func process_input(event: InputEvent) -> void:
	finished.emit(idle_firing)
