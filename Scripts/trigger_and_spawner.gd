extends Node

@export var enemy_scene: PackedScene
@onready var trigger: Area3D = $Trigger
@onready var spawns: Node3D = $Spawns

var triggerable : bool = true
var target : CharacterBody3D = null
var enemy_parent : Node = null

func init(targ: CharacterBody3D, enmy_par: Node):
	target = targ
	enemy_parent = enmy_par
	spawns.visible = false

func _on_trigger_body_entered(_body: Node3D) -> void:
	if not triggerable:
		return

	print("Triggered")
	
	for child in spawns.get_children():
		spawn_enemy(child.global_transform)
	
	triggerable = false

func spawn_enemy(pos : Transform3D) -> void:
	var new_enemy = enemy_scene.instantiate()
	new_enemy._change_target(target)
	enemy_parent.add_child(new_enemy)
	new_enemy.global_transform = pos
