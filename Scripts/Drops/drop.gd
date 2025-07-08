extends RigidBody3D
class_name Drop

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_3d: Area3D = $Area3D

func _ready() -> void:
	animation_player.get_animation("Idle").loop_mode = (Animation.LOOP_LINEAR)


func _on_area_3d_body_entered(body: Node3D) -> void:
	#Add drop to player inventory
	queue_free()

func _on_despawn_timeout() -> void:
	queue_free()
