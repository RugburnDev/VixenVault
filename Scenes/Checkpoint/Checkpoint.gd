extends Area2D


func _on_area_entered(_area: Area2D) -> void:
	hide()
	SignalManager.emit_on_level_won()
	SignalManager.emit_level_over(true)
	queue_free()


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "open":
		monitoring = true
