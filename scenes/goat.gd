extends Node2D

onready var debug = false
onready var decoy = null
onready var decoyer = load("res://scenes/player_decoy.tscn")

onready var run = false
onready var speed = 4.0
onready var player = null
onready var run_direction = Vector2(0.0, 0.0)
onready var run_limit = 0.0

export var peace_ratio = 2.0
onready var peace = 100.0

# give target and player reference to goat
func give_target(p, lock_x = true):
	# store player reference and start running
	player = p
	run = true
	# lock movement in axis
	if(lock_x):
		run_limit = player.get_pos().x
		if(player.get_pos().x > get_pos().x):
			run_direction = Vector2(1.0, 0.0)
		else:
			run_direction = Vector2(-1.0, 0.0)
	else:
		run_limit = player.get_pos().y
		if(player.get_pos().y > get_pos().y):
			run_direction = Vector2(0.0, 1.0)
		else:
			run_direction = Vector2(0.0, -1.0)

func _ready():
	set_fixed_process(true)
	# if scene is running as root, debug
	var root = get_node("/root")
	if(root.get_child(root.get_child_count()-1) == self):
		debug = true
	pass

func _fixed_process(delta):
	# run!
	if(run):
		set_pos(get_pos() + run_direction*speed)
		# stop before player
		if(run_direction == Vector2(1.0, 0.0)):
			if(get_pos().x >= run_limit or get_pos().x >= player.get_pos().x):
				run = false
		if(run_direction == Vector2(-1.0, 0.0)):
			if(get_pos().x <= run_limit or get_pos().x <= player.get_pos().x):
				run = false
		if(run_direction == Vector2(0.0, 1.0)):
			if(get_pos().y >= run_limit or get_pos().y >= player.get_pos().y):
				run = false
		if(run_direction == Vector2(0.0, -1.0)):
			if(get_pos().y <= run_limit or get_pos().y <= player.get_pos().y):
				run = false
	# create player decoy just to test goat movement
	if(debug):
		if Input.is_mouse_button_pressed(1):
			if(decoy == null):
				decoy = decoyer.instance()
				get_tree().get_root().add_child(decoy)
			give_target(decoy, Input.is_key_pressed(KEY_X))