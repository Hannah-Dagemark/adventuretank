extends Node

var upgrade_levels = {"speed": 0, "reload_speed": 0, "bullet_speed": 0, "bullet_damage": 0,}
var upgrade_data = {}

func _ready():
	load_upgrades()
	
func load_upgrades():
	var file = FileAccess.open("res://upgrades.json", FileAccess.READ)
	if file:
		upgrade_data = JSON.parse_string(file.get_as_text())
		file.close()
		
func get_modifier(stat: String) -> float:
	if upgrade_data.has(stat):
		var level = upgrade_levels[stat]
		return upgrade_data[stat][level] if level < upgrade_data[stat].size() else 1.0
	return 1.0
	
func upgrade_stat(stat: String):
	if upgrade_levels[stat] < 5:
		upgrade_levels[stat] += 1
		print(stat + " upgraded to level " + str(upgrade_levels[stat]))
