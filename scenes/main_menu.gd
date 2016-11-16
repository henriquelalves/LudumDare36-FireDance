
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# hiscore
	var global_hiscore = str(get_node("/root/global").read_hiscore())
	for i in range(0, 6 - global_hiscore.length()):
		global_hiscore = "0" + global_hiscore
	get_node("hiscore_global").set_text(global_hiscore)
	get_node("menu_options").connect("option_selected", self, "_option_chose")
	pass

func _option_chose(o):
	if o == 0:
		get_node("/root/global").change_scene(self, "res://scenes/stage.tscn")
	elif o == 1:
		get_tree().quit()