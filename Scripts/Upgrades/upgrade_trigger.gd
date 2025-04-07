extends Control

@onready var upgrade_menu = $"../UpgradeMenu"

func _ready():
	mouse_entered.connect(func(): upgrade_menu.show_menu(true))
	mouse_exited.connect(func(): upgrade_menu.show_menu(false))
