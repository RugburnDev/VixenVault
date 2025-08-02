extends Node



signal _on_player_died
signal _on_create_bullet(position:Vector2, direction:Vector2, speed:float, type:Constants.OBJECT_TYPE)
signal _on_create_object(position:Vector2, type:Constants.OBJECT_TYPE)
signal _on_scored(points:int)
signal _on_boss_killed
signal _on_level_won
signal _on_player_lives_update(lives:int, shake_cam:bool)
signal _level_over(complete: bool)

func emit_on_player_died() -> void:
	if Constants.DEBUG:
		print("SignalManager: Player Died")
	_on_player_died.emit()
	

func emit_level_over(complete: bool) -> void:
	if Constants.DEBUG:
		print("SignalManager: Level Over")
	_level_over.emit(complete)


func emit_on_create_bullet(position:Vector2, direction:Vector2, speed:float, type:Constants.OBJECT_TYPE) -> void:
	if Constants.DEBUG:
		print("SignalManager: Create Bullet %s" % type)
	_on_create_bullet.emit(position, direction, speed, type)


func emit_on_create_object(position:Vector2, type:Constants.OBJECT_TYPE):
	if Constants.DEBUG:
		print("SignalManager: Create Object %s" % type)
	_on_create_object.emit(position, type)
	

func emit_on_scored(points:int):
	if Constants.DEBUG:
		print("SignalManager: Score %d Points" % points)
	_on_scored.emit(points)


func emit_on_boss_killed() -> void:
	if Constants.DEBUG:
		print("SignalManager: Boss Killed")
	_on_boss_killed.emit()


func emit_on_level_won() -> void:
	if Constants.DEBUG:
		print("SignalManager: Level Won")
	_on_level_won.emit()


func emit_on_player_lives_update(lives:int, shake_cam:bool):
	if Constants.DEBUG:
		print("SignalManager: Player Lives Updated to %d. shake_cam: %s" % [lives, shake_cam])
	_on_player_lives_update.emit(lives, shake_cam)
