extends CharacterBody2D

@onready var asset_loader = $"../asset_loader"
@onready var muzzle = $Gun/Muzzle
@onready var gun = $Gun
@onready var reload_timer = $Gun/ReloadTimer
@onready var gun_default_pos = gun.position.x

var bullet_scene = preload("res://Scenes/bullet.tscn")
var static_enemy_scene = preload("res://Scenes/Enemies/static_enemy.tscn")

@export var max_speed: float = 300.0 # Top speed
@export var acceleration: float = 2.0 # How fast it speeds up
@export var friction: float = 2.0 # How fast it slows down

@export var rotation_speed : float = 5.0

@export var recoil_strength: float = 15.0  # How far the barrel moves back
@export var recoil_recovery_speed: float = 50.0  # How fast it moves back
@export var player_recoil_strength: float = 50.0  # How much the tank moves back
var recoil_offset: float = 0.0
var move_direction = Vector2.ZERO

#asset_loader stats
var barrel_stats
var enemy_stats
var upgrade_stats
var current_upgrades = {}

@export var fire_rate: float = 0.75  # Seconds between shots
var can_fire: bool = true
			

# INITIALIZERS

func _ready():
	if asset_loader.barrel_data.size() > 0:
		initialize_barrel()
	else:
		asset_loader.barrels_loaded.connect(initialize_barrel)
	if asset_loader.enemy_data.size() > 0:
		initialize_enemies()
	else:
		asset_loader.enemies_loaded.connect(initialize_enemies)
	if asset_loader.upgrade_data.size() > 0:
		initialize_upgrades()
	else:
		asset_loader.upgrades_loaded.connect(initialize_upgrades)
	if reload_timer == null:
		print("Error: ReloadTimer is missing!")
		return
	reload_timer.wait_time = fire_rate
	reload_timer.one_shot = true
	reload_timer.start()

func initialize_barrel():
	barrel_stats = asset_loader.get_barrel_stats("Cannon")
	print("\n", barrel_stats)
	
func initialize_enemies():
	enemy_stats = asset_loader.get_enemy_stats("all")
	print("\n", enemy_stats)

func initialize_upgrades():
	upgrade_stats = asset_loader.get_upgrade_stats()
	for stat in upgrade_stats.keys():
		current_upgrades[stat] = 0
	print("\n", upgrade_stats, "\n", current_upgrades)
	
# PROCESSORS

func _process(delta):
	var target_angle = (get_global_mouse_position() - global_position).angle()
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
	
	handle_movement(delta)
		
	recoil_offset = move_toward(recoil_offset, 0, recoil_recovery_speed * delta)
	$Gun.position.x = gun_default_pos + recoil_offset

	move_and_slide()

func _on_reload_timer_timeout():
	print("Timer resetting")
	can_fire = true
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			fire_bullet()
			can_fire = false  # Prevents rapid spam
			reload_timer.start()  # Restart timer


# ACTIONS

func spawn_static_enemy(type: String):
	
	var cur_enemy_stats = enemy_stats[type.to_lower()]
	
	var enemy = static_enemy_scene.instantiate()
	enemy.path = cur_enemy_stats.path
	enemy.sprite_modded = false
	enemy.health = cur_enemy_stats.hp
	enemy.max_health = enemy.health
	get_tree().current_scene.add_child(enemy)
	
func fire_bullet():
	if muzzle == null or bullet_scene == null: return
	
	var bullet = bullet_scene.instantiate()
	bullet.global_position = muzzle.global_position
	bullet.speed *= actual_upgrade("bullet_speed")
	bullet.direction = Vector2.RIGHT.rotated(rotation)
	bullet.damage = barrel_stats.damage
	get_tree().current_scene.add_child(bullet)
	
	recoil_offset = -recoil_strength
	velocity -= (Vector2.RIGHT.rotated(rotation) * player_recoil_strength )
	print("mov", move_direction, "vector", (Vector2.RIGHT.rotated(rotation) * player_recoil_strength ))
	 
	can_fire = false
	reload_timer.start(fire_rate)
	
# HELPERS

func actual_upgrade(upgrade: String) -> int:
	if upgrade_stats[upgrade]:
		return 1 + upgrade_stats[upgrade].progression * current_upgrades[upgrade]
	else:
		return 1
	
# INPUT

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if can_fire:
			fire_bullet()
			can_fire = false
			reload_timer.start()
	if event is InputEventKey and event.is_action_pressed("spawn_enemy"):
		var options = ["Hentagon", "Pexagon", "Square", "Triangle"]
		spawn_static_enemy(options.pick_random())

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
		velocity = velocity.lerp(move_direction * max_speed * actual_upgrade("speed"), acceleration * delta * actual_upgrade("speed"))

	else:
		velocity = velocity.lerp(Vector2.ZERO, friction * delta)
