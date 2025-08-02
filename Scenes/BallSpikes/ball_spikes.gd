extends PathFollow2D


@export var speed : float = 50.0
@export var spin_speed : float = 360

var _path : Path2D


func _ready() -> void:
	_path = get_parent()
	loop = FoxyUtils.is_path_loop(_path)
	

func _process(delta: float) -> void:
	progress += speed * delta
	rotation_degrees += spin_speed * delta
	if (progress_ratio == 1.0 and not loop) or (progress_ratio == 0.0 and not loop):
		speed = -speed
