extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var coll = $CollisionShape2D
@onready var animation = $AnimationPlayer
#@onready var projectile_base = get_tree().get_first_node_in_group("projectile_base")

@export var abilities : Array[Ability_Info]
var ability_scene : Array[Object]

@export var max_hp : int
var curr_hp : int = max_hp
@export var max_mana : int
var curr_mana : int = max_mana
@export var armor : int
@export var move_speed : int
@export var knock_back_recovery : float
var move_vec : Vector2 = Vector2.ZERO
var knock_back_applied : Vector2 = Vector2.ZERO

signal add_to_proj_base(object)

func _physics_process(delta):
	velocity = move_vec.normalized() * move_speed # delta not needed since move and sldie already factors in time 
	knock_back_applied = knock_back_applied.move_toward(Vector2.ZERO, knock_back_recovery)
	velocity += knock_back_applied
	if move_vec != Vector2.ZERO:
		if not animation.is_playing():
			animation.play("walk")
	else:
		if animation.is_playing():
			animation.stop()
			
	if move_vec.x > 0: # All sprites should face right at the beginning
		sprite.flip_h = false
	elif move_vec.x < 0: 
		sprite.flip_h = true
	#print(move_speed)
	#print(velocity)
	#print(move_vec)
	move_and_slide()

func _on_hurt_box_hurt(damage, angle, knockback):
	print("Hurt Box Triggered")
	knock_back_applied = angle * knockback
	curr_hp -= clamp(damage - armor, 1, 9999)
	if curr_hp <= 0:
		death()
	
func death():
	queue_free()

func load_ability(name):
	var scene = load("res://Abilities/" + name + "/" + name + ".tscn")
	var scenenode = scene.instantiate()
	emit_signal("add_to_proj_base",scenenode)
	return scenenode

func reload_abilities():
	ability_scene.clear()
	for i in abilities:
		print("Adding " + i.name)
		ability_scene.append(load_ability(i.name))
		#print("Ability_scene " + str(ability_scene.size()))
		

func post_load(): # Load abilites in reload_abilities
	reload_abilities()
