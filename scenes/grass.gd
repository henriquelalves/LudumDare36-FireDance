extends KinematicBody2D

onready var debug = false

onready var time_to_spawn = 0.0
onready var lock = false
onready var decoy = null
onready var decoyer = load("res://scenes/player_decoy.tscn")
onready var goater = preload("res://scenes/goat.tscn")
onready var spawner_reference = null

func set_goat_timer(t, l, r):
	time_to_spawn = t
	lock = l
	spawner_reference = r

func _ready():
	set_fixed_process(true)
	# test if it is debugging
	var root = get_node("/root")
	if(root.get_child(root.get_child_count()-1) == self):
		debug = true
	pass

func _fixed_process(delta):
	# Spawn clock
	if(time_to_spawn > 0.0):
		time_to_spawn -= delta
		if(time_to_spawn <= 0.0):
			time_to_spawn = 0.0
			var goat = goater.instance()
			spawner_reference.add_child(goat)
			goat.set_pos(get_pos())
			goat.give_target(lock)
	if(debug):
		if Input.is_mouse_button_pressed(1):
			if(decoy == null):
				decoy = decoyer.instance()
				get_tree().get_root().add_child(decoy)
			set_goat_timer(2.0, false)
