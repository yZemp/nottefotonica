extends FiringState
class_name AutoFiring

@export var idle_firing: FiringState
@export var firing: FiringState
@export var reloading: FiringState
@export var switching: FiringState

var fire_cooldown_ref

func enter(previous_state: FiringState, data: Dictionary = {}) -> void:
	statename = "AutoFiring"
	super(previous_state, data)
	
	if parent and parent.game_weapon:
		fire_cooldown_ref = parent.game_weapon.fire_cooldown
		if not fire_cooldown_ref.is_connected("timeout", Callable(self, "_on_fire_cooldown_timeout")):
			fire_cooldown_ref.connect("timeout", Callable(self, "_on_fire_cooldown_timeout"))
		try_fire() # Tenta il primo sparo immediatamente

func process_input(event: InputEvent) -> void:
	super(event)
	if Input.is_action_just_released("primary_fire"):
		finished.emit(idle_firing)
	
func process_physics(delta: float) -> void:
	pass
	
func exit():
	super()
	# Disconnetti il segnale quando si esce dallo stato per evitare connessioni multiple
	if fire_cooldown_ref and fire_cooldown_ref.is_connected("timeout", Callable(self, "_on_fire_cooldown_timeout")):
		fire_cooldown_ref.disconnect("timeout", Callable(self, "_on_fire_cooldown_timeout"))

func _on_fire_cooldown_timeout():
	try_fire()

func try_fire():
	# Tenta di sparare solo se l'arma può sparare (non in cooldown) e il tasto è premuto
	if parent.game_weapon.can_fire and Input.is_action_pressed("primary_fire"):
		parent.game_weapon.fire()
