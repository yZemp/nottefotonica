extends FiringState
class_name Switching

@export var idle_firing: FiringState
@export var firing: FiringState
@export var reloading: FiringState
@export var auto_firing: FiringState

func enter(previous_state: FiringState, data: Dictionary = {}) -> void:
	statename = "Switching"
	super(previous_state, data)
	
	if data.has("new_gun"):
		var new_gun: WeaponResource = data["new_gun"]
		if new_gun:
			parent.game_weapon.setup_weapon(new_gun)
			print("Succesfully changed weapon: ", new_gun.name)
		else:
			printerr("Switching with invalid weapon resource.")
	else:
		printerr("No weapon resource found.")
	
	# Qui puoi aggiungere logica per animazioni di cambio arma o un timer
	finished.emit(idle_firing)
	
