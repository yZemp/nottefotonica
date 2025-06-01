extends FiringState
class_name Switching

@export var idle_firing: FiringState
@export var firing: FiringState
@export var reloading: FiringState
@export var auto_firing: FiringState

func enter() -> void:
	statename = "Switching"
	super()

func process_input(event: InputEvent) -> FiringState:
	super(event)
	
	return null
	
func process_physics(delta: float) -> FiringState:
	return null
	
