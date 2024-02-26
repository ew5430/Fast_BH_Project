extends CanvasLayer
class_name GUI

@onready var score_label = $Control/MarginContainer/Score
@onready var timer = $Control/MarginContainer/Timer

var score = 0:
	set(new_score):
		score = new_score
		update_score_label()
		
		
func  update_score_label():
	score_label = str(score)

func _ready():
	update_score_label()
	
func on_gain_points(point_value : int):
	score += point_value
	
