
extends Node


const MAIN = preload("res://Scenes/Main/main.tscn")
const LEVEL_BASE = preload("res://Scenes/LevelBase/level_base.tscn")


const Levels: Array[PackedScene] = [
	preload("res://Scenes/LevelBase/level_1.tscn"),
	preload("res://Scenes/LevelBase/level_2.tscn")
]

const SCORES_PATH = "user://high_scores.tres"


var high_scores: HighScores = HighScores.new()
var _current_level: int = 0


# score to carry over between levels
var cached_score: int:
	set (value):
		cached_score = value
	get:
		return cached_score

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test") and Constants.DEBUG:
		load_next_level()

func _ready() -> void:
	load_high_scores()


func _exit_tree():
	save_high_scores()


func load_main():
	cached_score = 0
	_current_level = 0
	get_tree().change_scene_to_packed(MAIN)


func load_next_level():
	if _current_level >= Levels.size():
		_current_level = 0
	
	get_tree().change_scene_to_packed(Levels[_current_level])
	_current_level += 1


func load_high_scores():		
	if ResourceLoader.exists(SCORES_PATH):
		high_scores = load(SCORES_PATH)
		pass


func save_high_scores():
	ResourceSaver.save(high_scores, SCORES_PATH)


# try this each time game is over / level complete
func try_add_new_score(score: int):
	high_scores.add_new_score(score)
	save_high_scores()	
	cached_score = score
