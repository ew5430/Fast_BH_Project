extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var coll = $CollisionShape2D
@onready var animation = $AnimationPlayer

@export var abilities : Array[Ability_Info]
var ability_scene : Array[Object]
var ability_cooldowns : Array[Timer]
var world # Will be world space refernce

@export var max_hp : int
@onready var curr_hp : int = max_hp
@export var max_mana : int
@export var mana_regen : int
@onready var curr_mana : int = max_mana
@export var armor : int
@export var move_speed : int
@export var knock_back_recovery : float
@onready var move_vec : Vector2 = Vector2.ZERO
@onready var knock_back_applied : Vector2 = Vector2.ZERO

signal remove_from_world(object)

func _physics_process(_delta):
	velocity = move_vec.normalized() * move_speed # delta not needed since move and sldie already factors in time 
	knock_back_applied = knock_back_applied.move_toward(Vector2.ZERO, knock_back_recovery)
	velocity += knock_back_applied
	if move_vec != Vector2.ZERO:
		if move_vec.x > 0: # All sprites should face right at the beginning
			sprite.flip_h = false
		elif move_vec.x < 0: 
			sprite.flip_h = true
		if not animation.is_playing():
			animation.play("walk")
	else:
		if animation.is_playing():
			animation.stop()
	#print(move_speed)
	#print(velocity)
	#print(self," ",move_vec)
	move_and_slide()

func _on_hurt_box_hurt(damage, angle, knockback):
	print("Hurt Box Triggered ", damage," ", angle ," ", knockback," ")
	knock_back_applied = angle * knockback
	curr_hp -= clamp(damage - armor, 1, 9999)
	if curr_hp <= 0:
		death()
	
func death():
	emit_signal("remove_from_world",self)
	call_deferred("queue_free")

func reload_abilities():
	print("Loading abilites for ", self)
	ability_scene.clear()
	for i in ability_cooldowns:
		i.queue_free()
	ability_cooldowns.clear()
	for i in range(abilities.size()):
		print("Adding " + abilities[i].name)
		ability_scene.append(world.load_ability(abilities[i].name))
		var timer = Timer.new()
		timer.wait_time = abilities[i].cooldown
		timer.timeout.connect(abilities[i]._timer_timeout)
		add_child(timer)
		ability_cooldowns.append(timer)

func use_ability(index):
	if not abilities[index].on_cd and curr_mana >= abilities[index].mana_cost:
		ability_scene[index].execute(self)
		abilities[index]._start_cd()
		ability_cooldowns[index].start()
		curr_mana -= abilities[index].mana_cost

# Setup that occurs after the world scene is fully loaded
func post_load():
	world = get_tree().get_first_node_in_group("world")
	reload_abilities()
