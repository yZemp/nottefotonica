extends FiringState
class_name AutoFiring

@export var idle_firing: FiringState
@export var firing: FiringState
@export var reloading: FiringState
@export var switching: FiringState

func enter() -> void:
	statename = "AutoFiring"
	super()

func process_input(event: InputEvent) -> FiringState:
	super(event)
	
	return null
	
func process_physics(delta: float) -> FiringState:
	return null
	
