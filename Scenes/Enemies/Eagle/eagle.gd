extends EnemyBase

class_name Eagle


@export var fly_speed : Vector2 = Vector2(35, 15)


@onready var player_detector: RayCast2D = $PlayerDetector
@onready var direction_timer: Timer = $DirectionTimer
@onready var shooter: Shooter = $Shooter


var direction : int = [-1,1].pick_random()
var _seen_player : bool = false



func _physics_process(delta: float) -> void:
	super._pysics_process(delta)
	_fly()
	_flip() 
	_check_player_detector() 
	move_and_slide()


func _check_player_detector() -> void:
	if player_detector.is_colliding():
		if !_seen_player:
			_seen_player = true
			direction_timer.start()
		_shoot()


func _shoot() -> void:
	shooter.shoot(global_position.direction_to(_player_ref.global_position))


func _flip() -> void:
	animated_sprite_2d.flip_h = velocity.x > 0

func _fly() -> void:
	if _seen_player:
		velocity = fly_speed
		velocity.x *= direction
	

func _on_direction_timer_timeout() -> void:
	direction_timer.wait_time = randf_range(2.0, 4.0)
	direction_timer.start()
	direction = 1 if _player_ref.global_position.x > global_position.x else -1
	

func _on_screen_entered() -> void:
	if !_seen_player:
		_seen_player = true
		direction_timer.start()
