extends Node

@onready var trigger: Area3D = $Trigger
@onready var spawner: Area3D = $Spawner

var triggerable := true

signal triggered_spawner(spawn_area: Area3D)

func _on_trigger_body_entered(body: Node3D) -> void:
	if not triggerable:
		return
	triggered_spawner.emit(spawner)
	triggerable = false
