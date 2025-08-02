extends Node2D


@onready var hit_box: Area2D = $Visuals/HitBox
@onready var trigger: Area2D = $Trigger
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var shooter: Shooter = $Visuals/Shooter
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var visuals: Node2D = $Visuals
@onready var arrive_sound: AudioStreamPlayer2D = $ArriveSound


@export var lives : int = 3
@export var points : int = 5

var _player_ref : Player
var _invincible : bool = false


func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	if _player_ref == null:
		push_warning("unable to find the player!")
		queue_free()


func _take_damage() -> void:
	if !_invincible:
		lives -= 1
		if lives == 0: 
			_die()
		else:
			_set_invincible(true)
			state_machine.travel("hit")
			_tween_hit()


func _die() -> void:
	SignalManager.emit_on_scored(points)
	SignalManager.emit_on_create_object(visuals.global_position, Constants.OBJECT_TYPE.CHECKPOINT)
	SignalManager.emit_on_create_object(visuals.global_position, Constants.OBJECT_TYPE.EXPLOSION)
	call_deferred("queue_free")
	
	
func _set_invincible(on: bool) -> void:
	_invincible = on
	
	
func _tween_hit() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(visuals, "position", Vector2(0,0), 1.0)


func _on_trigger_area_entered(_area: Area2D) -> void:
	_disable_trigger()
	arrive_sound.play()
	animation_tree["parameters/conditions/on_trigger"] = true


func _on_hit_box_area_entered(_area: Area2D) -> void:
	_take_damage()


func _disable_trigger() -> void:
	trigger.set_deferred("monitoring", false)
	trigger.set_deferred("monitorable", false)
	
	
func _enable_hitbox() -> void:
	hit_box.set_deferred("monitoring", true)
	hit_box.set_deferred("monitorable", true)
	
func _shoot() -> void:
	shooter.shoot(shooter.global_position.direction_to(_player_ref.global_position))


func _on_you_win_sound_finished() -> void:
	pass
