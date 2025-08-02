extends Control

@onready var score_label: Label = $MarginContainer/ScoreLabel
@onready var lives_container: HBoxContainer = $MarginContainer/Lives
@onready var color_rect: ColorRect = $ColorRect
@onready var v_box_game_over: VBoxContainer = $ColorRect/VBoxGameOver
@onready var v_box_complete: VBoxContainer = $ColorRect/VBoxComplete
@onready var sound: AudioStreamPlayer = $Sound

const GAME_OVER = preload("res://assets/sound/game_over.ogg")
const YOU_WIN = preload("res://assets/sound/you_win.ogg")
const HEART = preload("res://Scenes/Heart/Heart.tscn")

var _score : int = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		GameManager.load_main()
	if event.is_action_pressed("shoot") and v_box_complete.visible:
		GameManager.load_next_level()


func _enter_tree() -> void:
	SignalManager._on_scored.connect(_on_scored)
	SignalManager._on_player_lives_update.connect(_on_player_lives_update)
	SignalManager._level_over.connect(_level_over)


func _exit_tree() -> void:
	GameManager.try_add_new_score(_score)


func _ready() -> void:
	_score = GameManager.cached_score
	_update_score_label() 


func _on_scored(points:int) -> void:
	_score += points
	_update_score_label()
	

func _update_score_label() -> void:
	score_label.text = "%04d" % _score


func _level_over(complete:bool) -> void:
	get_tree().paused = true
	color_rect.show()
	if complete:
		v_box_complete.show()
		sound.stream = YOU_WIN
	else:
		v_box_game_over.show()
		sound.stream = GAME_OVER
	sound.play()


func _on_player_lives_update(lives:int, _shake_cam:bool) -> void:
	for child : TextureRect in lives_container.get_children():
		child.queue_free()
	for i in range(lives):
		var heart = HEART.instantiate()
		lives_container.add_child(heart)
