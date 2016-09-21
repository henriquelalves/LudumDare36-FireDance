
extends Control

onready var debug = false
onready var global = get_node("/root/global")

onready var spawn_timer = 0.0
onready var spawn_timer_limit = 3.0
onready var fast_spawn = false

func spawn_goat():
	var r_direction = randi() % 2 # 0 = vertical, 1 = horizontal
	# search for spawning grass
	# p.m. could've used dinamically generated grass to make task easier,
	# but I wanted to see visually the effect of the grass on the stage 
	var grass = null
	if r_direction: # horizontal direction
		var lane = get_node("right")
		if randi() % 2 == 0: # spawn on left side
			lane = get_node("left")
		grass = lane.get_children()[randi()%lane.get_children().size()]
	else:
		var lane = get_node("bottom")
		if randi() % 2 == 0:  # spawn on top side
			lane = get_node("top")
		grass = lane.get_children()[randi()%lane.get_children().size()]
	
	grass.set_goat_timer(0.5, r_direction, self)

func _ready():
	randomize()
	set_fixed_process(true)
	
	global.fire_time = 60.0
	global.total_time = 0.0
	global.score = 0.0
	
	# debugging
	var root = get_node("/root")
	if(root.get_child(root.get_child_count()-1) == self):
		debug = true
	pass

func _fixed_process(delta):
	global.fire_time -= delta
	global.total_time += delta
	global.score += delta*100
	
	spawn_timer += delta
	if(spawn_timer >= spawn_timer_limit):
		spawn_timer -= spawn_timer_limit
		spawn_goat()
	
	if (fast_spawn == false):
		if global.total_time >= 30.0:
			fast_spawn = true
			spawn_timer = 1.5
	
	if debug:
		if Input.is_mouse_button_pressed(1):
			spawn_goat()