
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("menu_options").connect("option_selected", self, "_option_chose")
	
	# score
	var score = int(get_node("/root/global").score)
	var str_score = str(score)
	for i in range(0, 6 - str_score.length()):
		str_score = "0" + str_score
	get_node("score_global").set_text(str_score)
	
	if score > int(get_node("/root/global").read_hiscore()):
		get_node("new_hiscore").show()
		get_node("/root/global").write_hiscore(score)
	
	pass

func _option_chose(o):
	if o == 0:
		get_node("/root/global").change_scene(self, "res://scenes/stage.tscn")
	elif o == 1:
		get_node("/root/global").change_scene(self, "res://scenes/main_menu.tscn")


