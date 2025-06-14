extends FiringState
class_name AutoFiring

@export var idle_firing: FiringState
@export var firing: FiringState
@export var reloading: FiringState
@export var switching: FiringState

var fire_cooldown

func enter(previous_state: FiringState, data: Dictionary = {}) -> void:
	statename = "AutoFiring"
	super(previous_state, data)
	
	fire_cooldown = parent.game_weapon.fire_cooldown
	if not fire_cooldown.is_connected("timeout", Callable(self, "_on_fire_cooldown_timeout")):
		fire_cooldown.connect("timeout", Callable(self, "_on_fire_cooldown_timeout"))
		try_fire()

func process_input(event: InputEvent) -> void:
	super(event)
	if Input.is_action_just_released("primary_fire"):
		finished.emit(idle_firing)
	
func process_physics(delta: float) -> void:
	pass
	
func exit():
	var fire_cooldown = parent.game_weapon.fire_cooldown
	if fire_cooldown.is_connected("timeout", Callable(self, "_on_fire_cooldown_timeout")):
		fire_cooldown.disconnect("timeout", Callable(self, "_on_fire_cooldown_timeout"))

func _on_fire_cooldown_timeout():
	try_fire()

func try_fire():
	if parent.game_weapon.can_fire:
		parent.game_weapon.fire()
		parent.game_weapon.fire_cooldown.start()
