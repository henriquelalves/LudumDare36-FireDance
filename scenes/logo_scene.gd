
extends Control

var label_update = true
var time_changes = [0.0,0.23,0.61,0.95,1.3,1.5]
var ready = false
var colors = ["9bbc0f", "306230","8bac0f", "0f380f"]
var c_color = 0
var c_time = 0
var time = 0.0
var flicker = true
var label_string = "Illusion Fisherman"

func _ready():
	set_fixed_process(true)
	get_node("Label").set_text("")
	add_user_signal("finished_logo")
	get_node("Sprite/AnimationPlayer").connect("finished", self, "_finished_logo")
	pass

func _fixed_process(delta):
	if(ready == false):
		time += delta
		if(time > 1.0):
			time = 0.0
			get_node("SamplePlayer").play("illusion_fisherman_8bit")
			ready = true
	else:
		if(label_update):
			_label_run(delta)
		elif flicker:
			time += delta
			if time > 0.5:
				flicker = false
				get_node("Sprite/AnimationPlayer").play("flicker")
				get_node("SamplePlayer").play("shine")

func _label_run(delta):
	time += delta
	if time > time_changes[c_time]: #Update label beautifully
		c_time+=1
		if c_time < time_changes.size():
			c_color = (c_color + 1)%colors.size()
			var new_string = label_string.left(label_string.length() * (c_time/float(time_changes.size())))
			get_node("Label").set_text(new_string)
			get_node("Label").add_color_override("font_color", Color(colors[c_color]))
		else:
			label_update = false
			get_node("Label").set_text(label_string)
			get_node("Label").add_color_override("font_color", Color(colors[0]))
			time = 0

func _finished_logo():
	# fadeout
	if(get_node("Sprite/AnimationPlayer").get_current_animation() == "flicker"):
		get_node("Sprite/AnimationPlayer").play("fade_out")
	if(get_node("Sprite/AnimationPlayer").get_current_animation() == "fade_out"):
		emit_signal("finished_logo")

func finished():
	get_node("/root/global").change_scene(self, "res://scenes/main_menu.tscn")