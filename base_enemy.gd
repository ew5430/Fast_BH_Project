extends "res://Utilities/Base_Unit.gd"

@onready var search_space = $SearchSpace
var move_target = position

func set_target():
	if search_space.in_range.size() > 0:
		var min_dist = 9999
		var min_obj = null
		for i in search_space.keys():
			if i.is_in_group("friendly"):
				var dist = self.position.distance_to(i.position)
				if dist < min_dist:
					min_dist = dist
					min_obj = i
		
		move_target = min_obj.position

func chaser_ai():
	set_target()

func patrol_ai():
	move_target = position + Vector2(randi_range(-100,100), randi_range(-100,100))

func ai_control(): # TODO: How to properly do intelligent AI
	pass

func _physics_process(delta):
	move_vec = self.position.direction_to(move_target)
	super(delta)

