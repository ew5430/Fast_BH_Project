extends Label

@export var base_time : int
@onready var pass_time = base_time

signal time_checkpoint_hit(curr_time) # TODO: Things change over time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass_time -= delta
	change_time()

func change_time():
	var time = int(pass_time)
	var m = int(time / 60.0)
	var s = time % 60
	if m < 10:
		m = str(0, m)
	if s < 10:
		s = str(0, s)
	
	self.text = str(m, ":", s)
	#lbl_timer.text = str(m, ":", s)
