extends Control

@onready var grid_container: GridContainer = $MarginContainer/GridContainer
const HIGHSCORE_DISPLAY = preload("res://Scenes/HighscoreDisplay/highscore_display.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		GameManager.load_next_level()
	elif Input.is_key_pressed(KEY_Q):
		get_tree().quit()


func _ready() -> void:
	get_tree().paused = false
	_set_scores() 


func _set_scores() -> void:
	for score : HighScore in GameManager.high_scores.get_scores_list():
		var hsd : HighScoreDisplayItem = HIGHSCORE_DISPLAY.instantiate()
		hsd.setup(score)
		grid_container.add_child(hsd)
