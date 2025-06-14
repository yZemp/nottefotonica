extends FiringState
class_name Firing

@export var idle_firing: FiringState
@export var auto_firing: FiringState
@export var reloading: FiringState
@export var switching: FiringState

var fire_cooldown

func enter(previous_state: FiringState, data: Dictionary = {}) -> void:
	statename = "Firing"
	super(previous_state, data)
	parent.game_weapon.fire()
	parent.game_weapon.fire_cooldown.start()
	
	fire_cooldown = parent.game_weapon.fire_cooldown
	if not fire_cooldown.is_connected("timeout", Callable(self, "_on_fire_cooldown_timeout")):
		fire_cooldown.connect("timeout", Callable(self, "_on_fire_cooldown_timeout"))

func process_input(event: InputEvent) -> void:
	super(event)
	
func _on_fire_cooldown_timeout():
	finished.emit(idle_firing)
	
func exit() -> void:
	if fire_cooldown.is_connected("timeout", Callable(self, "_on_fire_cooldown_timeout")):
		fire_cooldown.disconnect("timeout", Callable(self, "_on_fire_cooldown_timeout"))
