extends "res://Utilities/base_enemy.gd"

func _ready():
	print("Calling ready from ", self)
	abilities.append(Ability_Info.new("Sword"))


func chaser_ai():
	super()
	if current_target != null and position.distance_to(current_target.position) < 100:
		#print(self, " is attacking. ", current_target)
		ability_scene[0].execute(self) # Summon a sword
		pass
