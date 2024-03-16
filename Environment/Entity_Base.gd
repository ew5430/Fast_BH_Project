extends Node

@onready var player = preload("res://Player/player.tscn")
@export var spawn_power : int = 0
@onready var enemies : Array[Object] = [] # Store the possible enemies to spawn in an array
@onready var enemy_names : Array[String] = []

func spawn_player(player_pos: Vector2):
	var p = player.instantiate()
	p.position = player_pos
	add_child(p)

func spawn_enemies(level_size: Vector2, camera_size: Vector2): # Try to get random enemy spawns
	var start_index : int = randi_range(0,enemy_names.size() - 1)
	var curr_index : int = start_index
	var fail_match : int = 0
	while spawn_power > 0 and fail_match < 2:
		# TODO: Find out how to properly call functions on loaded scenes
		var curr_enemy : Array = DataContainer.get_enemy(enemy_names[curr_index])
		var curr_enemy_spawn_cost : int = int(curr_enemy[DataContainer.get_enemy_property_index("SpawnCost")])
		if curr_enemy_spawn_cost <= spawn_power:
			# Spawn the chosen enemy a random number of times
			var times = int(spawn_power / curr_enemy_spawn_cost)
			times -= randi_range(0,int(times / 3))
			times = max(times,1)
			spawn_power -= curr_enemy_spawn_cost * times
			for i in range(times):
				# TODO: Add spawn locations as arguments for spawn, and generate them here
				var spawn_loc : Vector2 = Vector2(randi_range(0,level_size.x) - camera_size.x, randi_range(0,level_size.y) - camera_size.y)
				
				var e = enemies[curr_index].instantiate()
				for new_e in e.spawn(spawn_loc, []):
					add_child(new_e)
			start_index = curr_index
			fail_match = 0

		curr_index += 1
		if curr_index == enemies.size():
			curr_index = 0
		if curr_index == start_index: # Does 2 passes to ensure that nothing left can be spawned
			fail_match += 1


func load_enemies(biome : String, distance : int): # Put enemies into the enemies list
	enemies.clear()
	enemy_names.clear()
	var biome_index = DataContainer.ENEMY_PROPERTIES.find("SpawnInfo") - 1 # Remove 1 since name is ignored
	for i in DataContainer.ENEMIES: # i is the name of the enemy
		var enemy_val = DataContainer.ENEMIES[i]
		# Check if enemy can spawn in this biome, and if we are at right distance
		print(enemy_val)
		if enemy_val[biome_index].has(biome) and distance >= enemy_val[biome_index][biome][0] and distance <= enemy_val[biome_index][biome][1]:
			enemies.append(load("res://Enemy/" + i + ".tscn"))
			enemy_names.append(i)
