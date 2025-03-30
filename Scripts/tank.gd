extends CharacterBody2D

@onready var asset_loader = $"../asset_loader"
@onready var muzzle = $Gun/Muzzle
@onready var gun = $Gun
@onready var reload_timer = $Gun/ReloadTimer
@onready var gun_default_pos = gun.position.x

@export var bullet_scene: PackedScene

@export var max_speed: float = 300.0 # Top speed
@export var acceleration: float = 2.0 # How fast it speeds up
@export var friction: float = 2.0 # How fast it slows down

@export var rotation_speed : float = 5.0

@export var recoil_strength: float = 15.0  # How far the barrel moves back
@export var recoil_recovery_speed: float = 50.0  # How fast it moves back
@export var player_recoil_strength: float = 50.0  # How much the tank moves back
var recoil_offset: float = 0.0
var move_direction = Vector2.ZERO

@export var fire_rate: float = 0.75  # Seconds between shots
var can_fire: bool = true

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if can_fire:
			fire_bullet()
			can_fire = false  # Prevents rapid spam
			reload_timer.start()  # Restart timer
			
func _ready():
	Upgrades.load_upgrades()
	if asset_loader.barrel_data.size() > 0:
		initialize_barrel()
	else:
		asset_loader.barrels_loaded.connect(initialize_barrel)
	if reload_timer == null:
		print("Error: ReloadTimer is missing!")
		return
	reload_timer.wait_time = fire_rate
	reload_timer.one_shot = true
	reload_timer.start()
	
func _process(delta):
	var target_angle = (get_global_mouse_position() - global_position).angle()
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
	
	handle_movement(delta)
		
	recoil_offset = move_toward(recoil_offset, 0, recoil_recovery_speed * delta)
	$Gun.position.x = gun_default_pos + recoil_offset

	move_and_slide()
	
func fire_bullet():
	if muzzle == null or bullet_scene == null: return
	
	var bullet = bullet_scene.instantiate()
	bullet.global_position = muzzle.global_position
	bullet.speed *= Upgrades.get_modifier("bullet_speed")
	bullet.direction = Vector2.RIGHT.rotated(rotation)
	get_tree().current_scene.add_child(bullet)
	
	recoil_offset = -recoil_strength
	velocity -= (Vector2.RIGHT.rotated(rotation) * player_recoil_strength )
	print("mov", move_direction, "vector", (Vector2.RIGHT.rotated(rotation) * player_recoil_strength ))
	  
	can_fire = false
	reload_timer.start(fire_rate)
	
func initialize_barrel():
	var stats = asset_loader.get_barrel_stats("Cannon")
	print(stats)
	
func _on_reload_timer_timeout():
	print("Timer resetting")
	can_fire = true
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			fire_bullet()
			can_fire = false  # Prevents rapid spam
			reload_timer.start()  # Restart timer
	
func handle_movement(delta):
	move_direction = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		move_direction.y -= 1
	if Input.is_action_pressed("move_down"):
		move_direction.y += 1
	if Input.is_action_pressed("move_left"):
		move_direction.x -= 1
	if Input.is_action_pressed("move_right"):
		move_direction.x += 1
		
	if move_direction != Vector2.ZERO:
		move_direction = move_direction.normalized()
		velocity = velocity.lerp(move_direction * max_speed * Upgrades.get_modifier("speed"), acceleration * delta * Upgrades.get_modifier("speed"))
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction * delta)
