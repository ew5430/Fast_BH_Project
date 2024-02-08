extends "res://Utilities/Base_Unit.gd"

#@onready var walktimer = get_node("%WalkTimer") # Alternate way to get, like $, but needs unique name to be set

# GUI
#@onready var expBar = get_node("%EXP_Bar")
#@onready var level_label = get_node("%Level_label")
#@onready var healthBar = get_node("%HealthBar")

#var sword
func _ready():
	#var a = Ability_Info.new("Sword")
	abilities.append(Ability_Info.new("Sword"))

func _physics_process(delta):
	player_movement()
	super(delta)
	shoot()
	
func player_movement():
	var xmov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var ymov = Input.get_action_strength("down") - Input.get_action_strength("up")

	move_vec = Vector2(xmov,ymov)
	
func shoot():
	if Input.is_action_pressed("click"):
		var mouse_pos = get_viewport().get_mouse_position()
		if mouse_pos.x < position.x:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
			
		for i in ability_scene:
			#print("Execute Caller")
			#print(i.name)
			i.execute(self)

