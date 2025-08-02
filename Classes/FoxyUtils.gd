class_name FoxyUtils

static func formatted_dt() -> String:
	var dt = Time.get_datetime_dict_from_system()
	return "%02d/%02d/%02d" % [dt.day, dt.month, dt.year]
	
	
static func is_path_loop(path : Path2D) -> bool:
	if path.curve.get_point_count() < 3:
		return false

	var first_point = path.curve.get_point_position(0)
	var last_point = path.curve.get_point_position(path.curve.get_point_count() - 1)
	
	return first_point.distance_to(last_point) < 1e-2
