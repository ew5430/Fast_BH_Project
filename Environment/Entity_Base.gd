extends Node

@onready var player = preload("res://Player/player.tscn")
@export var spawn_power : int = 15
@onready var enemies : Array[Object] = [] # Store the possible enemies to spawn in an array 

func load_player(player_pos: Vector2):
	var p = player.instantiate()
	p.position = player_pos
	add_child(p)
	#for

func spawn_enemies(level_size: Vector2, camera_size: Vector2):
	enemies.shuffle() # Try to get random enemy spawns
	var start_index = 0
	var curr_index = 0
	var fail_match = 0
	while spawn_power > 0 and fail_match < 2:
		if enemies[curr_index].spawn_cost <= spawn_power:
			# Spawn the chosen enemy a random number of times
			var times = int(spawn_power / enemies[curr_index].spawn_cost)
			times -= randi_range(0,int(times / 3))
			times = max(times,1)
			spawn_power -= enemies[curr_index].spawn_cost * times
			for i in range(times):
				# TODO: Add spawn locations as arguments for spawn, and generate them here
				for e in enemies[curr_index].spawn():
					add_child(e)
			start_index = curr_index
			fail_match = 0

		curr_index += 1
		if curr_index == enemies.size():
			curr_index = 0
		if curr_index == start_index: # Does 2 passes to ensure that nothing left can be spawned
			fail_match += 1


func load_enemies(biome : String, distance : int): # Put enemies into the enemies list TODO
	var biome_index = DataContainer.ENEMY_PROPERTIES.find("SpawnInfo") - 1 # Remove 1 since name is ignored
	for i in DataContainer.ENEMIES: # i is the name of the enemy
		var enemy_val = DataContainer.ENEMIES[i]
		# Check if enemy can spawn in this biome, and if we are at right distance
		if enemy_val[biome_index].has(biome) and distance >= enemy_val[biome_index][biome][0] and distance <= enemy_val[biome_index][biome][1]:
			enemies.append(load("res://Enemy/" + i + ".tscn"))
