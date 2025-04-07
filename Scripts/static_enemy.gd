extends Node2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var health_bar = $HealthBar

@onready var sprite_modded : bool
@export var path : String 
@export var max_health : float 
@export var health : float

var direction: Vector2
var timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.max_value = max_health
	health_bar.value = health
	health_bar.visible = false
	add_to_group("enemies")
	if (sprite_modded):
		print("Support coming soon")
	else:
		var path = "res://Assets/" + path
		if FileAccess.file_exists(path):
			sprite.texture = load(path)
		else:
			print("File, ", path, " not found")
		
	# Set initial random movement direction
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	# Set initial position (optional)
	position = Vector2(randf_range(100, 500), randf_range(100, 500))  # Random start position

func take_damage(damage):
	print("Took damage")
	health -= damage
	health_bar.visible = true
	health_bar.value = health
	if (health <= 0):
		queue_free()
