extends Control

var tween: Tween

func _ready():
	Upgrades.load_upgrades()
	populate_upgrades()
	position.x = -size.x
	visible = true

func show_menu(show: bool):
	print("Should show")
	if tween:
		tween.kill()
	tween = create_tween()
	var target_x = 0 if show else -size.x
	tween.tween_property(self, "position:x", target_x, 0.3).set_trans(Tween.TRANS_SINE)

func populate_upgrades():
	# Clear previous UI
	for child in get_children():
		child.queue_free()

	# Create buttons for each upgradFeable stat
	for stat in Upgrades.upgrade_data.keys():
		var button = Button.new()
		button.text = "%s (Level %d)" % [stat, Upgrades.upgrade_levels.get(stat, 0)]
		button.name = stat
		button.pressed.connect(func(): apply_upgrade(stat))
		add_child(button)

func apply_upgrade(stat: String):
	Upgrades.upgrade_levels[stat] += 1
	update_ui(stat)

func update_ui(stat: String):
	var button = get_node(stat)
	if button:
		button.text = "%s (Level %d)" % [stat, Upgrades.upgrade_levels[stat]]
