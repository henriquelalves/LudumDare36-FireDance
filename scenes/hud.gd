extends Control

onready var debug = false

onready var time_bitter = load("res://scenes/time_bit.tscn")
onready var time_bits = []
onready var bits_on = 10
onready var global = get_node("/root/global")

func update_score_hud():
	var str_score = str(int(global.score))
	if str_score.length() > 6:
		return get_node("score_label").set_text("999999")
	else:
		for i in range(0, 6 - str_score.length()):
			str_score = "0" + str_score
		return get_node("score_label").set_text(str_score)

func update_time_hud():
	var new_bits = int(global.fire_time/6.0)+1
	if(new_bits != bits_on):
		for i in range(0, new_bits-1):
			time_bits[i].set_bit(true)
		for i in range(new_bits, 10):
			time_bits[i].set_bit(false)
		bits_on = new_bits

func _ready():
	set_fixed_process(true)
	# create time bits
	for i in range(0, 10):
		var time_bit = time_bitter.instance()
		time_bit.set_pos(Vector2(266 + (8*i),16))
		add_child(time_bit)
		time_bits.append(time_bit)
	
	# if scene is running as root, debug
	var root = get_node("/root")
	if(root.get_child(root.get_child_count()-1) == self):
		global.fire_time = 60.0
		debug = true

func _fixed_process(delta):
	update_score_hud()
	update_time_hud()
	# debugging
	if(debug):
		global.fire_time -= delta
		global.score += 10.0
	pass