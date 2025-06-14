extends FiringState
class_name Reloading

@export var idle_firing: FiringState
@export var firing: FiringState
@export var auto_firing: FiringState
@export var switching: FiringState

func enter(previous_state: FiringState, data: Dictionary = {}) -> void:
	statename = "Reloading"
	super(previous_state, data)
