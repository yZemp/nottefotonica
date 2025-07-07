extends RigidBody3D
class_name drop

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.get_animation("Idle").loop_mode = (Animation.LOOP_LINEAR)

func drop(parent: CharacterBody3D) -> void:
	pass
