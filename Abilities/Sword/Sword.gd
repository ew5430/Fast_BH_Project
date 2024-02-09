extends Node

var sword = preload("res://Abilities/Sword/Sword_Inst.tscn")

func execute(s):
	#print("Execute Called")
	var direction
	if s.is_in_group("player"):
		direction = s.get_local_mouse_position().angle()
	else:
		direction = s.position.angle_to(s.current_target.position)
	var new_sword = sword.instantiate()
	new_sword.config(s,s.position, direction)
	add_child(new_sword)
