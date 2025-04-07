extends Node2D

@export var speed: float = 600.0
@export var direction: Vector2
@export var damage: float

func _process(delta):
	position += direction * speed * delta


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("HIT SOMETHING!!")
	var target = area.get_parent()
	if target.is_in_group("enemies"):
		if target.has_method("take_damage"):
			target.take_damage(10)
		else:
			print("Area could not take damage")
		queue_free()
	else: 
		print("Group not designated")
