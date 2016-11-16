extends Node

onready var score = 0.0
onready var fire_time = 0.0
onready var total_time = 0.0

onready var player_ref = null

var save = File.new()
var save_path = "user://savegame.save"
var save_data = {"hiscore": 0}

func _ready():
	randomize()
	
	# create save file
	if not save.file_exists(save_path):
		save.open(save_path, File.WRITE)
		save.store_var(save_data)
		save.close()

func read_hiscore():
	save.open(save_path, File.READ)
	save_data = save.get_var()
	save.close()
	return save_data["hiscore"]

func write_hiscore(hiscore):
	save_data["hiscore"] = hiscore
	save.open(save_path, File.WRITE)
	save.store_var(save_data)
	save.close()

func change_scene(scn, scn_to):
	var parent = scn.get_parent()
	var Scn_to = load(scn_to)
	var new_scene = Scn_to.instance()
	parent.add_child(new_scene)
	scn.queue_free()