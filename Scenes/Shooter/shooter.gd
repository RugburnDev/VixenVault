extends Node2D

class_name Shooter


@onready var shoot_timer: Timer = $ShootTimer
@onready var sound: AudioStreamPlayer2D = $Sound

@export var _speed : float = 100.0
@export var _bullet_key : Constants.OBJECT_TYPE = Constants.OBJECT_TYPE.BULLET_PLAYER
@export var _shoot_delay : float = 1.0


var _can_shoot : bool = true


func _ready() -> void:
	shoot_timer.wait_time = _shoot_delay
	
	if _bullet_key != Constants.OBJECT_TYPE.BULLET_ENEMY and _bullet_key != Constants.OBJECT_TYPE.BULLET_PLAYER :
		push_error("%s: Bullet Key must be 'Bullet Player' or 'Bullet Enemy'" % get_parent())


func shoot(direction: Vector2) -> void:
	if _can_shoot:
		print("shoot: ", direction)
		sound.play()
		SignalManager.emit_on_create_bullet(global_position, direction,_speed, _bullet_key)
		_can_shoot = false
		shoot_timer.start()


func _on_shoot_timer_timeout() -> void:
	_can_shoot = true
