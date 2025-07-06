extends Node

@export var enemy_scene: PackedScene
@onready var trigger: Area3D = $Trigger
@onready var proton_scatter: Node3D = $ProtonScatter

var triggerable := true

signal spawn_enemy(spawn_location: Node3D, enemy_scene: PackedScene)

func _ready() -> void:
	proton_scatter.visible = false

func _on_trigger_body_entered(_body: Node3D) -> void:
	if not triggerable:
		return
	
	print("Triggered")
	
	# THERE MUST EXIST A BETTER WAY!
	for i in get_children():
		if i.get_child_count() > 0:
			for j in i.get_children():
				if j.get_child_count() > 0:
					for k in j.get_children():
						for spawner in k.get_children():
							#print("Emitting pos:\t", spawner.PackedVector3Array[0])
							spawn_enemy.emit(spawner, enemy_scene)
	
	#triggered_spawner.emit()
	triggerable = false
