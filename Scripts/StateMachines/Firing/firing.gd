extends FiringState
class_name Firing

@export var idle_firing: FiringState
@export var auto_firing: FiringState
@export var reloading: FiringState
@export var switching: FiringState

func enter() -> void:
	statename = "Firing"
	super()
	parent.game_weapon.fire()

func process_input(event: InputEvent) -> FiringState:
	super(event)
	
	return idle_firing
	
func process_physics(delta: float) -> FiringState:
	return null
	
