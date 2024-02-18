extends Node

@onready var ENEMIES = {}
var ENEMY_PROPERTIES : Array
@onready var ABILITES = {}

func parse_enemies():
	# Read data from csv and save into array
	var csv = []
	var file = FileAccess.open("res://Data/enemies.csv", FileAccess.READ)
	while !file.eof_reached():
		var csv_rows = file.get_csv_line("\t")
		csv.append(csv_rows)
	file.close()
	
	csv.pop_back() #remove last empty array get_csv_line() has created 
	ENEMY_PROPERTIES = Array(csv[0])
	print(ENEMY_PROPERTIES)
	#var some_header_idx = headers.find("some_header_name")
	csv.pop_front() #remove first array (headers) from the csv
	print(csv)
	for i in csv:
		i.remove_at(0)
		ENEMIES[i[0]] = i
	print(ENEMIES)

