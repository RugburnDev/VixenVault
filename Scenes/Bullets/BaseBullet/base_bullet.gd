extends Area2D

class_name Bullet

var _direction : Vector2 = Vector2(50,-50)
@onready var ray_cast_2d: RayCast2D = $RayCast2D



func _ready() -> void:
	pass


func _setup(pos:Vector2, dir:Vector2, speed:float) -> void:
	_direction = dir.normalized() * speed
	global_position = pos


func _physics_process(delta: float) -> void:
	position += _direction * delta
	if ray_cast_2d.is_colliding():
		queue_free()
		

func _on_area_entered(_area: Area2D) -> void:
	queue_free()
