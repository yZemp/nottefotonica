extends "res://Scripts/Drops/drop.gd"

@export var heal_amount: float = 20.

func custom_function(body: Node3D):
	if "take_healing" in body:
		body.take_healing(heal_amount)
