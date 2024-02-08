extends Resource
class_name Ability_Info

@export var cooldown : float
@export var mana_cost: int
@export var name : String
@export var description : String

func _init(a_name = "temp", cd = 10, mc = 10, a_description = ""):
	cooldown = cd
	name = a_name
	description = a_description
	mana_cost = mc
