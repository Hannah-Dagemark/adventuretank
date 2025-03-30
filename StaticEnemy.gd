extends Node2D

@export var textures : Array[Texture2D]  # Export array of Texture2D
@export var speed : float = 100           # Speed at which the enemy moves
@export var float_amplitude : float = 50  # Amplitude of the floating movement
@export var float_speed : float = 1.0     # Speed of the floating movement

var sprite: Sprite2D
var direction: Vector2
var timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Sprite2D  # Ensure this is the Sprite2D node (changed from Sprite in Godot 4)
	
	if textures.size() > 0:
		set_random_texture()
	
	# Set initial random movement direction
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	# Set initial position (optional)
	position = Vector2(randf_range(100, 500), randf_range(100, 500))  # Random start position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Move the enemy in a straight line
	position += direction * speed * delta
	
	# Make it float vertically based on time (sine wave movement)
	position.y += sin(timer * float_speed) * float_amplitude
	
	# Update the timer for floating effect
	timer += delta

	# Boundary check or wraparound (optional)
	if position.x < 0:
		position.x = get_viewport_rect().size.x
	elif position.x > get_viewport_rect().size.x:
		position.x = 0
	
	if position.y < 0:
		position.y = get_viewport_rect().size.y
	elif position.y > get_viewport_rect().size.y:
		position.y = 0

# Function to assign a random texture to the sprite
func set_random_texture():
	var random_index = randi_range(0, textures.size() - 1)
	sprite.texture = textures[random_index]
