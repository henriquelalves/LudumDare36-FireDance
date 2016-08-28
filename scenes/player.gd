extends Node2D

export var speed = 2.0

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if (Input.is_key_pressed(KEY_UP)):
			set_pos(get_pos() + Vector2(0.0, -speed))
	elif (Input.is_key_pressed(KEY_DOWN)):
		set_pos(get_pos() + Vector2(0.0, speed))
	elif (Input.is_key_pressed(KEY_RIGHT)):
		set_pos(get_pos() + Vector2(speed, 0.0))
	elif (Input.is_key_pressed(KEY_LEFT)):
		set_pos(get_pos() + Vector2(-speed, 0.0))