extends EnemyBase

@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _physics_process(delta: float) -> void:
	super._pysics_process(delta)
	
	velocity.y += _gravity * delta
	velocity.x = speed if animated_sprite_2d.flip_h else -speed
	
	
	velocity.y = clampf(velocity.y, jump_strength, terminal_velocity)
	move_and_slide()
	_flip()


func _flip() -> void:
	if is_on_wall() or !ray_cast_2d.is_colliding():
		animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
		ray_cast_2d.position.x = -ray_cast_2d.position.x
