extends Node

signal barrels_loaded
signal enemies_loaded
signal upgrades_loaded

var barrel_data = {}
var enemy_data = {}
var upgrade_data = {}

func _ready():
	load_barrel_data()
	load_enemy_data()
	load_upgrade_data()

# LOADER FUNCTIONS:

func load_enemy_data():
	var file = FileAccess.open("res://Json/enemies.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		enemy_data = JSON.parse_string(content) if content else {}
		enemy_data = enemy_data.get("static_enemies", {})
		file.close()
		enemies_loaded.emit()
	else:
		push_error("Failed to load Enemies JSON")
	
	
func load_barrel_data():
	var file = FileAccess.open("res://Json/barrels.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		barrel_data = JSON.parse_string(content) if content else {}
		file.close()
		barrels_loaded.emit()
	else:
		push_error("Failed to load Barrels JSON")

func load_upgrade_data():
	var file = FileAccess.open("res://Json/upgrades.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		upgrade_data = JSON.parse_string(content) if content else {}
		file.close()
		upgrades_loaded.emit()
	else:
		push_error("Failed to load Upgrades JSON")

# GETTER FUNCTIONS:

func get_enemy_stats(enemy: String) -> Dictionary:
	if (enemy == "all"):
		return enemy_data
	else:
		return enemy_data.get(enemy, {})

	
func get_barrel_stats(barrel_name: String) -> Dictionary:
	print("Sending Barrel Data")
	return barrel_data.get(barrel_name, {})
	
func get_upgrade_stats() -> Dictionary:
	return upgrade_data
