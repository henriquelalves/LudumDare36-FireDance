extends KinematicBody2D

onready var debug = false
onready var decoy = null
onready var decoyer = load("res://scenes/player_decoy.tscn")

onready var run = false
export var speed = 3.0
onready var player = null
onready var run_direction = Vector2(0.0, 0.0)
onready var on_fire = false

export var health_ratio = 2.0
onready var health = 100.0

# give target and player reference to goat
func give_target(lock_x = true):
	get_node("health_bar").hide()
	run = true
	get_node("CollisionShape2D").set_trigger(true)
	# lock movement in axis
	if(lock_x):
		if(player.get_pos().x > get_pos().x):
			run_direction = Vector2(1.0, 0.0)
			get_node("AnimationPlayer").play("move_right",1,2)
		else:
			run_direction = Vector2(-1.0, 0.0)
			get_node("AnimationPlayer").play("move_left",1,2)
	else:
		if(player.get_pos().y > get_pos().y):
			run_direction = Vector2(0.0, 1.0)
			get_node("AnimationPlayer").play("move_down",1,2)
		else:
			run_direction = Vector2(0.0, -1.0)
			get_node("AnimationPlayer").play("move_up",1,2)

func _ready():
	set_fixed_process(true)
	add_to_group("goats")
	get_node("fire_sprite").hide()
	player = get_node("/root/global").player_ref
	# hiding health-bar and connecting signals
	get_node("health_bar").hide()
	get_node("health_bar").connect("bottom_percentage", self, "_when_health_min")
	# if scene is running as root, debug
	var root = get_node("/root")
	if(root.get_child(root.get_child_count()-1) == self):
		debug = true
	pass

func _fixed_process(delta):
	# run!
	if(run):
		move(run_direction*speed)
		# check for collisions
		var bodes = get_node("Area2D").get_overlapping_bodies() # bodes hahaha
		for bode in bodes:
			if(bode.is_in_group("goats") and bode != self): # both goats bump
				bode._bump()
				_bump()
				break
			elif(bode.is_in_group("player")): # hit player
				if (player.has_method("hit")):
					player.hit()
			elif(bode.is_in_group("fire")): # catch fire and gain more points (Im not really sure why)
				on_fire = true
		# stop before player axis
		if(run_direction == Vector2(1.0, 0.0)):
			if(get_pos().x >= player.get_pos().x):
				run = false
				get_node("CollisionShape2D").set_trigger(false)
				get_node("AnimationPlayer").play("sit")
		if(run_direction == Vector2(-1.0, 0.0)):
			if(get_pos().x <= player.get_pos().x):
				run = false
				get_node("CollisionShape2D").set_trigger(false)
				get_node("AnimationPlayer").play("sit")
		if(run_direction == Vector2(0.0, 1.0)):
			if(get_pos().y >= player.get_pos().y):
				run = false
				get_node("CollisionShape2D").set_trigger(false)
				get_node("AnimationPlayer").play("sit")
		if(run_direction == Vector2(0.0, -1.0)):
			if(get_pos().y <= player.get_pos().y):
				run = false
				get_node("CollisionShape2D").set_trigger(false)
				get_node("AnimationPlayer").play("sit")
	else: #being pacified
		if(!get_node("health_bar").is_visible()):
			get_node("health_bar").set_health_scale(1.0)
			get_node("health_bar").show()
		
		get_node("health_bar").set_health_scale_relative(-0.004)
		
#		I'm leaving this code here for posterity; it was a discarded
#		idea of a mechanic in which the player would "pacify" goats by
#		standing still close to them. This wasn't working - the game
#		was becoming dull, even for the simple idea I was trying to implement.
#		That's when I created the butterfly and noticed the game, if not 
#		fun, became at least something resambling more like a mini-game
#		of some sorts.

#		if(player):
#			if((player.get_pos()-get_pos()).length() <= 36.0):
#				if(player.has_method("is_moving") and player.is_moving() == false):
#					get_node("health_bar").set_health_scale_relative(0.006)
#				else:
#					get_node("health_bar").set_health_scale_relative(-0.004)
#			else:
#				get_node("health_bar").set_health_scale_relative(-0.004)
		
	# create player decoy just to test goat movement
	if(debug):
		if Input.is_mouse_button_pressed(1):
			if(decoy == null):
				decoy = decoyer.instance()
				get_tree().get_root().add_child(decoy)
				player = decoy
			give_target(Input.is_key_pressed(KEY_X))


func _when_health_min():
	queue_free()

func _bump():
	get_node("/root/global").score += 500.0
	if(on_fire):
		get_node("/root/global").score += 250.0 # small secret point bonus here
	queue_free()