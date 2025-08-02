extends Node2D

const OBJECT_SCENES : Dictionary[Constants.OBJECT_TYPE, PackedScene] = {
	Constants.OBJECT_TYPE.EXPLOSION: preload("res://Scenes/Explosion/explosion.tscn"),
	Constants.OBJECT_TYPE.PICKUP: preload("res://Scenes/FruitPickup/fruit_pickup.tscn"),
	Constants.OBJECT_TYPE.BULLET_PLAYER: preload("res://Scenes/Bullets/PlayerBullet/player_bullet.tscn"),
	Constants.OBJECT_TYPE.BULLET_ENEMY: preload("res://Scenes/Bullets/EnemyBullet/enemy_bullet.tscn"),
	Constants.OBJECT_TYPE.CHECKPOINT: preload("res://Scenes/Checkpoint/Checkpoint.tscn")
}

func _enter_tree() -> void:
	SignalManager._on_create_bullet.connect(_on_create_bullet)
	SignalManager._on_create_object.connect(_on_create_object)


func _add_to_scene(new_child:Variant) -> void:
	call_deferred("add_child", new_child)


func _on_create_bullet(pos:Vector2, direction:Vector2, speed:float, type:Constants.OBJECT_TYPE):
	if OBJECT_SCENES.has(type):
		var nb: Bullet = OBJECT_SCENES[type].instantiate()
		nb._setup(pos, direction, speed)
		_add_to_scene(nb)
	else:
		push_error(type, " not found by object manager.")


func _on_create_object(pos:Vector2, type:Constants.OBJECT_TYPE):
	if OBJECT_SCENES.has(type):
		if type == Constants.OBJECT_TYPE.BULLET_PLAYER or type == Constants.OBJECT_TYPE.BULLET_ENEMY:
			push_warning("Bullet should be created using _on_create_bullet. Normal mechanics will not work")
		var n_obj: Node2D = OBJECT_SCENES[type].instantiate()
		n_obj.position = pos
		_add_to_scene(n_obj)
	else:
		push_error(type, " not found by object manager.")
