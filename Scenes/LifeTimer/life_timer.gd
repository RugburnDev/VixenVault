extends Node

class_name  LifeTimer

@export var life_time : float = 20.0


func _ready() -> void:
	await get_tree().create_timer(life_time).timeout
	get_parent().call_deferred("queue_free")
