extends CharacterBody2D

class_name EnemyBase


const fell_off_map : float = 100.0


@export var hit_points : int = 1
@export var points : int = 1
@export var speed : float = 30.0
@export var jump_strength : float = 0.0
@export var terminal_velocity : float = 300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@warning_ignore("unused_private_class_variable")
var _gravity : float = 690.0
var _player_ref : Player

#region builtins
func _ready() -> void:
	_player_ref = get_tree().get_first_node_in_group(Constants.PLAYER_GROUP)
	if _player_ref == null:
		push_warning("unable to find the player!")
		queue_free()

func _pysics_process(_delta: float) -> void:
	_check_off_map()
#endregion

#region misc
func _check_off_map() -> void:
	if global_position.y > fell_off_map:
		print("enemy fell off map.")
		queue_free()
#endregion

#region actions
func _die() -> void:
	set_physics_process(false)
	SignalManager.emit_on_create_object(global_position, Constants.OBJECT_TYPE.PICKUP)
	SignalManager.emit_on_create_object(global_position, Constants.OBJECT_TYPE.EXPLOSION)
	SignalManager.emit_on_scored(points)
	queue_free()
#endregion

#region signals
func _on_screen_entered() -> void:
	pass # Replace with function body.


func _on_screen_exited() -> void:
	pass # Replace with function body.
	

func _on_hit_box_area_entered(_area: Area2D) -> void:
	hit_points -= 1
	if hit_points <= 0:
		_die()
#endregion
