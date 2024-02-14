extends Node

var sword = preload("res://Abilities/Sword/Sword_Inst.tscn")

func execute(s):
	#print("Execute Called")
	var direction
	var layer
	if s.is_in_group("player"):
		direction = s.get_local_mouse_position().angle()
		layer = 3
	else:
		direction = (s.current_target.position - s.position).angle()
		layer = 2
	var new_sword = sword.instantiate()
	new_sword.config(s,s.position, direction, layer)
	add_child(new_sword)
