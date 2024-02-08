extends Area2D

var parent
var swing_time : float
var damage : int

func config(s=null,pos=Vector2(0,0), rot = 0, dmg = 5,swing_speed = 0.6, size = Vector2(1,1)):
	#print("Config Called")
	parent = s
	position = pos
	rotation = rot + deg_to_rad(180)
	scale = size
	swing_time = swing_speed
	damage = dmg 

	#$CollisionShape2D.add_collision_exception(s) figure out how to properly stop collisions with player

	
func _ready():
	var tween = create_tween()
	tween.tween_property(self,"rotation",rotation + deg_to_rad(180),swing_time)
	tween.tween_callback(queue_free)
	tween.play()

func _physics_process(_delta):
	position = parent.position
