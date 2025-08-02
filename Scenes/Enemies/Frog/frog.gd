extends EnemyBase

class_name Frog

const JUMP_VELOCITY : Vector2 = Vector2(100, -200)

@onready var jump_timer: Timer = $JumpTimer
@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


var _seen_player : bool = false
var _can_jump : bool = false


# gravity
func _physics_process(delta: float) -> void:
	super._pysics_process(delta)
	velocity.y += _gravity * delta
	
	_check_on_floor()
	_apply_jump()
	_face_player()

	move_and_slide()
#face player

			
func _face_player() -> void:
	if _seen_player:
		animated_sprite_2d.flip_h = _player_ref.global_position.x > global_position.x


func _apply_jump() -> void:
	if is_on_floor() and _can_jump and _seen_player:
		var direction : int = 1 if animated_sprite_2d.flip_h else -1
		velocity = JUMP_VELOCITY
		velocity.x *= direction * randf_range(0.5, 1.0)
		animated_sprite_2d.play("jump")
		_reset_jump_timer()


func _check_on_floor() -> void:
	if is_on_floor() and animated_sprite_2d.animation != "idle" :
		animated_sprite_2d.play("idle")
		velocity.x = 0.0

func _reset_jump_timer() -> void:
	_can_jump = false
	jump_timer.wait_time = randf_range(2.0, 3.0)
	jump_timer.start()


func _on_jump_timer_timeout() -> void:
	_can_jump = true
	
	
func _on_screen_entered() -> void:
	if !_seen_player:
		print("Frog saw player")
		_seen_player = true
		_reset_jump_timer()
