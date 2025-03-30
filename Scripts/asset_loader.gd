extends Node

signal barrels_loaded

var barrel_data = {}

func _ready():
	load_barrel_data()
	
func load_barrel_data():
	var file = FileAccess.open("res://Json/barrels.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		barrel_data = JSON.parse_string(content) if content else {}
		file.close()
		barrels_loaded.emit()
	else:
		push_error("Failed to load Barrels JSON")
	
func get_barrel_stats(barrel_name: String) -> Dictionary:
	print("Sending Barrel Data")
	return barrel_data.get(barrel_name, {})
