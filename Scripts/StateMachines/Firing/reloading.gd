extends FiringState
class_name Reloading

@export var idle_firing: FiringState
@export var firing: FiringState
@export var auto_firing: FiringState
@export var switching: FiringState

func enter() -> void:
	statename = "Reloading"
	super()

func process_input(event: InputEvent) -> FiringState:
	super(event)
	
	return null
	
func process_physics(delta: float) -> FiringState:
	return null
	
