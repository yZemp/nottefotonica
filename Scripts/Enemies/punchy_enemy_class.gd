extends Enemy
class_name PunchyEnemy

@export var RANGE := 2.0
@export var RANGE_HIT_MOD := 1.3
@export var TARGETING_DISTANCE := 30.
var can_hit := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
