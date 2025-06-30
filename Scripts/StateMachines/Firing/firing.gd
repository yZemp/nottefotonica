extends FiringState
class_name Firing

@export var idle_firing: FiringState
@export var auto_firing: FiringState
@export var reloading: FiringState
@export var switching: FiringState

var fire_cooldown_ref

func enter(previous_state: FiringState, data: Dictionary = {}) -> void:
	statename = "Firing"
	super(previous_state, data)
	
	if parent and parent.game_weapon:
		parent.game_weapon.fire()
		
		# Collega il segnale di timeout del timer dell'arma al metodo locale
		fire_cooldown_ref = parent.game_weapon.fire_cooldown
		if not fire_cooldown_ref.is_connected("timeout", Callable(self, "_on_fire_cooldown_timeout")):
			fire_cooldown_ref.connect("timeout", Callable(self, "_on_fire_cooldown_timeout"))

func process_input(event: InputEvent) -> void:
	super(event)
	
func _on_fire_cooldown_timeout():
	finished.emit(idle_firing)
	
func exit() -> void:
	super()
	if fire_cooldown_ref.is_connected("timeout", Callable(self, "_on_fire_cooldown_timeout")):
		fire_cooldown_ref.disconnect("timeout", Callable(self, "_on_fire_cooldown_timeout"))
