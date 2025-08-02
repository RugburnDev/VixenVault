extends CharacterBody2D

class_name Player


@onready var shooter: Shooter = $Shooter
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var debug_label: Label = $DebugLabel
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var fall_timer: Timer = $FallTimer
@onready var hurt_timer: Timer = $HurtTimer
@onready var hit_box: Area2D = $HitBox
@onready var player_cam: Camera2D = $PlayerCam


const JUMP = preload("res://assets/sound/jump.wav")
const DAMAGE = preload("res://assets/sound/damage.wav")

const GRAVITY : float = 690.0
const JUMP_STRENGTH : float = -300.0
const RUN_SPEED : float = 150.0
const TERMINAL_VELOCITY : float = 350.0
const HURT_JUMP_VELOCITY : Vector2 = Vector2(60.0, -130.0)

@export var fell_off_map : float = 100.0
@export var lives : int = 5
@export var camera_min : Vector2 = Vector2.ZERO
@export var camera_max : Vector2 = Vector2.ZERO

var _is_hurt : bool = false


func _ready() -> void:
	if Constants.DEBUG:
		debug_label.show()
	set_camera_limits() 
	call_deferred("_late_init")


func set_camera_limits() -> void:
	@warning_ignore("narrowing_conversion")
	player_cam.limit_bottom = camera_min.y
	@warning_ignore("narrowing_conversion")
	player_cam.limit_left = camera_min.x
	@warning_ignore("narrowing_conversion")
	player_cam.limit_top = camera_max.y
	@warning_ignore("narrowing_conversion")
	player_cam.limit_right = camera_max.x

func _late_init() -> void:
	SignalManager.emit_on_player_lives_update(lives, false)


func _enter_tree() -> void:
	add_to_group(Constants.PLAYER_GROUP)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shooter.shoot(Vector2.LEFT if sprite_2d.flip_h else Vector2.RIGHT)


func _update_debug_label() -> void:
	if Constants.DEBUG:
		var ds : String = "Flr: %s\nV: %.1f,%.1f\nP: %.1f,%.1f" \
			% [is_on_floor(), velocity.x, velocity.y, global_position.x, global_position.y]
		debug_label.text = ds
	
	
func _check_off_map() -> void:
	if global_position.y > fell_off_map:
		SignalManager.emit_on_player_died()
		queue_free()
	
	
func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	_get_input() 
	_flip()
	velocity.y = clampf(velocity.y, JUMP_STRENGTH, TERMINAL_VELOCITY)
	move_and_slide()
	_update_debug_label()
	_check_off_map()


func _flip() -> void:
	if not is_equal_approx(velocity.x, 0.0): # flip sprite
		sprite_2d.flip_h = velocity.x < 0


func _get_input() -> void:
	if !_is_hurt:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			_play_effect(JUMP)
			velocity.y = JUMP_STRENGTH
		
		if Input.is_action_pressed("fall") and is_on_floor():
			set_collision_mask_value(1, false)
			fall_timer.start()

		velocity.x = Input.get_axis("left","right") * RUN_SPEED

func _play_effect(effect: AudioStream) -> void:
	sound.stop()
	sound.stream = effect
	sound.play()


func _on_fall_timer_timeout() -> void:
	set_collision_mask_value(1, true)


func _apply_hit(area: Area2D) -> void:
	_is_hurt = true
	_set_invincible()
	hurt_timer.start()
	_play_effect(DAMAGE)
	_apply_hit_jump(area)
	_take_life(1)


func _take_life(damage:int) -> void:
	lives -= damage
	SignalManager.emit_on_player_lives_update(lives, true)
	if lives <= 0: #die
		_die()
		

func _die() -> void:
	set_physics_process(false)
	SignalManager.emit_on_player_died()
	SignalManager.emit_level_over(false)


func _set_invincible() -> void:
	hit_box.set_collision_mask_value(4, false)
	hit_box.set_collision_mask_value(5, false)
	_flash_sprite()
	

func _flash_sprite() -> void:
	var tween : Tween = create_tween()
	for i in range(4):
		tween.tween_property(sprite_2d, "modulate", Color("#ffffff", 0.2),0.3)
		tween.tween_property(sprite_2d, "modulate", Color("#ffffff", 1.0),0.3)
	tween.tween_callback(_set_mortal)
	

func _set_mortal() -> void:
	hit_box.set_collision_mask_value(4, true)
	hit_box.set_collision_mask_value(5, true)


func _apply_hit_jump(area: Area2D) -> void:
	var vel = HURT_JUMP_VELOCITY
	if area.global_position.x > global_position.x:
		vel.x *= -1
	velocity = vel


func _on_hit_box_area_entered(area: Area2D) -> void:
	call_deferred("_apply_hit", area)


func _on_hurt_timer_timeout() -> void:
	_is_hurt = false
