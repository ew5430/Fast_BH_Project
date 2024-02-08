extends Node

var sword = preload("res://Abilities/Sword/Sword_Inst.tscn")

func execute(s):
	#print("Execute Called")
	var direction = s.get_local_mouse_position().angle()
	var new_sword = sword.instantiate()
	new_sword.config(s,s.position, direction)
	add_child(new_sword)
