extends Resource
class_name Ability_Info

@export var cooldown : float
@export var mana_cost: int
@export var name : String
@export var description : String
var on_cd : bool

func _init(a_name = "temp", cd = 1, mc = 0, a_description = ""):
	cooldown = cd
	name = a_name
	description = a_description
	mana_cost = mc
	on_cd = false

func _start_cd():
	print(name,"  on_cd set to true")
	on_cd = true

func _timer_timeout():
	print(name," timer timed out, on_cd set to false")
	on_cd = false
