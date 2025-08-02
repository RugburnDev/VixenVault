extends VBoxContainer


class_name HighScoreDisplayItem


@onready var score_label: Label = $ScoreLabel
@onready var time_label: Label = $TimeLabel



var _high_score : HighScore = null



func _ready() -> void:
	if _high_score == null:
		queue_free()
	else:
		score_label.text = "%04d"  % _high_score.score
		time_label.text = _high_score.date_scored
		_animate()


func setup(highscore: HighScore) -> void:
	_high_score = highscore
	

func _animate() -> void:
	modulate =  Color("#ffffff", 0.0)
	var tween : Tween = create_tween()
	tween.tween_property(self, "modulate", Color("#ffffff", 1.0), 0.8)
