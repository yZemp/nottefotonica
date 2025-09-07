extends "res://Scripts/Drops/drop.gd"

@export var weapon_drop : WeaponResource

func custom_function(body: Node3D):
	if not weapon_drop:
		printerr("No weapon drop initialized")
	
	if "_add_weapon_to_inventory" in body:
		body._add_weapon_to_inventory(weapon_drop)
