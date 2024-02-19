extends Node2D


@onready var phys_obj_base = $Physical_Obj_Base
@onready var entity_base = $Entity_Base
@onready var proj_base = $Projectile_Base
@onready var tile_base = $Tile_Base
@onready var in_proj_base  = {} # Dictonary of attack nodes and how many users
#@onready var 

@export var level_size : Vector2 = Vector2(100,100)
@export var camera_size : Vector2 = Vector2(100,100)


func _ready(): # Need to use postload since ready of children called before ready of parent
	print("Loading Data")
	DataContainer.parse_enemies()
	
	print("Calling Post Load on Entities")
	for e in entity_base.get_children():
		e.connect("remove_from_world",_on_remove_from_world)
		e.post_load()
	tile_base.generate_chunk(level_size,camera_size)
	entity_base.load_enemies("Forest",0)
	entity_base.spawn_enemies(level_size,camera_size)
	#tile_base.unload_chunk(level_size,camera_size)

func load_ability(name : String):
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

func _on_remove_from_world(object: Object):
	print("Removing ", object)
	#print(proj_base.get_child_count())
	for i in object.abilities: # Track number of things using the ablity singltons
		in_proj_base[i.name] -= 1

	""" # Instances only created/cleared on world creation/deletion
		if in_proj_base[i.name] <= 0:
			proj_base.find_child(i.name,false,false).queue_free()
	"""
	# queue free will automaticly remove from entity base
	#print(entity_base.get_child_count())
