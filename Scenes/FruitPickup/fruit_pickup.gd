extends Area2D


@export var points : int = 2


@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound: AudioStreamPlayer2D = $Sound


func _ready() -> void:
	var ln : Array[String] = []
	for animation_name in _animated_sprite.sprite_frames.get_animation_names():
		ln.append(animation_name)
	_animated_sprite.animation = ln.pick_random()
	_animated_sprite.play()


func _on_area_entered(_area: Area2D) -> void:
	hide()
	set_deferred("monitoring", false)
	sound.play()
	SignalManager.emit_on_scored(points)


func _on_sound_finished() -> void:
	queue_free()
