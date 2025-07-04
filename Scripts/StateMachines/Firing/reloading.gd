extends FiringState
class_name Reloading

@export var idle_firing: FiringState
@export var firing: FiringState
@export var auto_firing: FiringState
@export var switching: FiringState

func enter(previous_state: FiringState, data: Dictionary = {}) -> void:
	statename = "Reloading"
	super(previous_state, data)
	parent.game_weapon.animation_player.play("Reload")
	print("Reloading weapon:\t", parent.game_weapon.weapon_data.name)
	
	await get_tree().create_timer(parent.game_weapon.weapon_data.reload_time).timeout
	if parent.firing_state_machine.current_state != self:
		print("Not reloading anymore")
		return
		
	parent.game_weapon.current_ammo = parent.game_weapon.weapon_data.max_ammo
	finished.emit(idle_firing)
