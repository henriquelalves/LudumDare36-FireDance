extends KinematicBody2D

export var speed = 2.0
onready var moving = false
onready var hit = false

func is_moving():
	return moving or hit

func hit():
	hit = true

func _ready():
	set_fixed_process(true)
	add_to_group("player")
	get_node("/root/global").player_ref = self
	pass

func _fixed_process(delta):
	# Movement
	moving = true
	if (Input.is_key_pressed(KEY_UP)):
		move(Vector2(0.0, -speed))
	elif (Input.is_key_pressed(KEY_DOWN)):
		move(Vector2(0.0, speed))
	elif (Input.is_key_pressed(KEY_RIGHT)):
		move(Vector2(speed, 0.0))
	elif (Input.is_key_pressed(KEY_LEFT)):
		move(Vector2(-speed, 0.0))
	else:
		moving = false