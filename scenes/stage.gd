
extends Control

onready var debug = false

func spawn_goat():
	var r_direction = randi() % 2 # 0 = vertical, 1 = horizontal
	print(r_direction)
	# search for spawning grass
	# p.m. could've used dinamically generated grass to make task easier,
	# but I wanted to see visually the effect of the grass on the stage 
	var grass = null
	if r_direction: # horizontal direction
		var lane = get_node("right")
		if get_node("Player").get_pos().x < 352.0/2.0: # spawn on left side
			lane = get_node("left")
		for g in lane.get_children():
			if grass == null or abs(grass.get_pos().y - get_node("Player").get_pos().y) > abs(g.get_pos().y - get_node("Player").get_pos().y):
				grass = g
	else:
		var lane = get_node("bottom")
		if get_node("Player").get_pos().y < 352.0/2.0: # spawn on top side
			lane = get_node("top")
		for g in lane.get_children():
			if grass == null or abs(grass.get_pos().x - get_node("Player").get_pos().x) > abs(g.get_pos().x - get_node("Player").get_pos().x):
				grass = g
	
	grass.set_goat_timer(1.0, r_direction, self)

func _ready():
	randomize()
	set_fixed_process(true)
	# debugging
	var root = get_node("/root")
	if(root.get_child(root.get_child_count()-1) == self):
		debug = true
	pass

func _fixed_process(delta):
	if debug:
		if Input.is_mouse_button_pressed(1):
			spawn_goat()