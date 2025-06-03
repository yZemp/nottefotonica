extends FiringState
class_name Idle_firing

@export var firing: FiringState
@export var auto_firing: FiringState
@export var reloading: FiringState
@export var switching: FiringState

func enter() -> void:
	statename = "Idle"
	super()

func process_input(event: InputEvent) -> FiringState:
	super(event)

	if Input.is_action_just_pressed("primary_fire") and parent.game_weapon.can_fire:
		return firing
	
	if Input.is_action_just_pressed("slot2"):
		return switching
	
	return null
	
func process_physics(delta: float) -> FiringState:
	return null
	
