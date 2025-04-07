extends Node

var upgrade_levels = {}
var upgrade_data = {}
	
func _ready():
	load_upgrades()
	
func load_upgrades():
	var file = FileAccess.open("res://upgrades.json", FileAccess.READ)
	if file:
		upgrade_data = JSON.parse_string(file.get_as_text())
		file.close()
		for stat in upgrade_data.keys():
			upgrade_levels[stat] = 0
		
func get_modifier(stat: String) -> float:
	if upgrade_data.has(stat):
		var level = upgrade_levels.get(stat, 0)
		var progression = upgrade_data[stat].get("progression", 0.0)
		return 1.0 + (progression * level)
	return 1.0
	
func upgrade_stat(stat: String):
	if upgrade_levels[stat] < 5:
		upgrade_levels[stat] += 1
		print(stat + " upgraded to level " + str(upgrade_levels[stat]))
