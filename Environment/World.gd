extends Node2D


@onready var phys_obj_base = $Physical_Obj_Base
@onready var entity_base = $Entity_Base
@onready var proj_base = $Projectile_Base

func _ready():
	print("Calling Post Load on Entities")
	for e in entity_base.get_children():
		e.post_load()

func _on_add_to_proj_base(object):
	print("Add to projectile base triggered ", object)
	proj_base.add_child(object)
	#print(proj_base.get_child_count())
