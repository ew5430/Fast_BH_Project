extends Node

# Reference for how to import CSV into godot
# https://github.com/godotengine/godot/issues/19627

enum tile_layers {
	BACKGROUND,
	PHYSICAL,
	DESTRUCTIBLE,
	FOREGROUND,
}

@onready var ENEMIES = {}
var ENEMY_PROPERTIES : Array
@onready var ABILITES = {}

func parse_enemies():
	# Read data from csv and save into array
	var csv = []
	var file = FileAccess.open("res://Data/enemies.csv", FileAccess.READ)
	while !file.eof_reached():
		var csv_rows = file.get_csv_line(",")
		csv.append(csv_rows)
	file.close()
	
	csv.pop_back() #remove last empty array get_csv_line() has created 
	ENEMY_PROPERTIES = Array(csv[0])
	print(ENEMY_PROPERTIES)
	csv.pop_front() #remove first array (headers) from the csv
	
	var items : Array = []
	var multi_item_dict : Dictionary = {}
	var multi_item_list : Array = []
	for i in csv: # Iterate over csv
		print(i)
		items.clear()
		var enemy_name = i[0]
		i.remove_at(0)
		for j in range(i.size()): # Iterate over csv line items
			multi_item_dict.clear()
			multi_item_list = i[j].split(",")
			if enemies_parse_multi(j, multi_item_list, multi_item_dict):
				items.append(multi_item_dict.duplicate(true))
			else:
				items.append(i[j])
		ENEMIES[enemy_name] = items.duplicate(true)
	print(ENEMIES)
	
func enemies_parse_multi(index : int, item_list : Array, item_dict : Dictionary) -> bool:
	var item_index : int = 0
	match ENEMY_PROPERTIES[index + 1]: # Increase index by 1 to account for removal of name
		"SpawnInfo":
			while item_index < item_list.size():
				item_dict[item_list[item_index]] = Vector2(int(item_list[item_index + 1]), int(item_list[item_index + 2]))
				item_index += 3
			return true
		"Abilites":
			while item_index < item_list.size():
				item_dict[item_list[item_index]] = true
				item_index += 1
			return true
	return false

func get_enemy(name : String) -> Array:
	return ENEMIES[name]

func get_enemy_property_index(name : String) -> int:
	return ENEMY_PROPERTIES.find(name) - 1 # Account for removal of name field

func parse_abilites():
	pass
