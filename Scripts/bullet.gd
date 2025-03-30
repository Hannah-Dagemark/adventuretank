extends Node2D

@export var speed: float = 600.0
@export var direction: Vector2

func _process(delta):
	position += direction * speed * delta
