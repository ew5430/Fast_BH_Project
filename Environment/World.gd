extends Node2D


@onready var phys_obj_base = $Physical_Obj_Base
@onready var entity_base = $Entity_Base
@onready var proj_base = $Projectile_Base
@onready var in_proj_base  = {} # Dictonary of attack nodes and how many users

func _ready(): # Need to use postload since ready of children called before ready of parent
	print("Calling Post Load on Entities")
	for e in entity_base.get_children():
		e.connect("remove_from_world",_on_remove_from_world)
		e.post_load()

func load_ability(name):
	if name not in in_proj_base:
		print("Loading new projectile ", name)
		var scene = load("res://Abilities/" + name + "/" + name + ".tscn")
		var scenenode = scene.instantiate()
		in_proj_base[name] = 1
		proj_base.add_child(scenenode)
		return scenenode
	else:
		print("Projectile Already in Base ", name)
		in_proj_base[name] += 1
		return proj_base.find_child(name,false,false)



func _on_remove_from_world(object):
	print(proj_base.get_child_count())
	for i in object.abilities: # Track number of things using the ablity singltons
		in_proj_base[i.name] -= 1
	""" # Instances only created/cleared on world creation/deletion
		if in_proj_base[i.name] <= 0:
			proj_base.find_child(i.name,false,false).queue_free()
	"""
	# TODO: Still need to determine if queue free will automaticly remove from entity base
	print(entity_base.get_child_count())
