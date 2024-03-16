extends MarginContainer

@onready var MapNodes = $MarginContainer/BackGround

@export var tileIconSize : Vector2 = Vector2(20,20)
@export var mapSize : Vector2 = Vector2(5,5)

# World gen will create grayed
func _ready():
	#center =
	await get_tree().process_frame
	setup()
	setVisibility()
	pass

func setup():
	#var center : Vector2 =  Vector2(0,0)
	var center : Vector2 =  MapNodes.size / 2
	for i in range(2 * mapSize.x + 1):
		for j in range(2 * mapSize.y + 1):
			var c = ColorRect.new()
			c.size = tileIconSize
			c.position = center + (i - mapSize.x) * tileIconSize * Vector2(1,0)  + (j - mapSize.y) * tileIconSize * Vector2(0,1)
			#TODO: Set color accoring to biome type
			c.color = Color(randi_range(-255,255),randi_range(-255,255),randi_range(-255,255)) 
			MapNodes.add_child(c)

func moveMap(move : Vector2):
	for c in MapNodes.get_children():
		c.position += move * tileIconSize
	setVisibility()

func setVisibility():
	for c in MapNodes.get_children():
		if c.position.x + tileIconSize.x > MapNodes.size.x or c.position.y + tileIconSize.y > MapNodes.size.y or c.position.x < 0 or c.position.y < 0:
			c.visible = false
		else:
			c.visible = true
