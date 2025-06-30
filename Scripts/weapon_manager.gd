extends Node

@export var weapons: Array[WeaponResource] # Tutte le definizioni delle armi del gioco

func _ready() -> void:
	print("WeaponManager ready; loaded weapons:\t", weapons.size())
	for weapon_res in weapons:
		if weapon_res:
			print("- ", weapon_res.name)

# Restituisce una risorsa arma dato il suo indice nell'array
func get_weapon_resource_by_index(index: int) -> WeaponResource:
	if index >= 0 and index < weapons.size():
		return weapons[index]
	printerr("Error: Invalid weapon index: ", index)
	return null

# Potresti anche voler aggiungere una funzione per ottenere armi per nome/ID
func get_weapon_resource_by_name(name: String) -> WeaponResource:
	for weapon_res in weapons:
		if weapon_res and weapon_res.name == name:
			return weapon_res
	printerr("Errore: Invalid weapon name: ", name)
	return null
