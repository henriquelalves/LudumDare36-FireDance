extends KinematicBody2D

export var speed = 1.0
onready var moving = false
onready var hit_timer = 0.0
onready var hit_timer_limit = 2.0
onready var hit = false

func is_moving():
	return moving

func hit():
	# Gameover
	if(hit == false):
		hit = true
		get_node("AnimationPlayer").play("game_over")
		get_node("CollisionShape2D").set_trigger(true)
	pass

func game_over():
	get_tree().change_scene("res://scenes/game_over.tscn")

func _ready():
	set_fixed_process(true)
	add_to_group("player")
	get_node("AnimationPlayer").play("dance")
	get_node("/root/global").player_ref = self
	pass

func _fixed_process(delta):
	# Movement
	moving = true
	if(hit == false):
		if (Input.is_key_pressed(KEY_UP)):
			move(Vector2(0.0, -speed))
			if(get_node("AnimationPlayer").get_current_animation() != "move_up"):
				get_node("AnimationPlayer").set_current_animation("move_up")
		elif (Input.is_key_pressed(KEY_DOWN)):
			move(Vector2(0.0, speed))
			if(get_node("AnimationPlayer").get_current_animation() != "move_down"):
				get_node("AnimationPlayer").set_current_animation("move_down")
		elif (Input.is_key_pressed(KEY_RIGHT)):
			move(Vector2(speed, 0.0))
			if(get_node("AnimationPlayer").get_current_animation() != "move_right"):
				get_node("AnimationPlayer").set_current_animation("move_right")
		elif (Input.is_key_pressed(KEY_LEFT)):
			move(Vector2(-speed, 0.0))
			if(get_node("AnimationPlayer").get_current_animation() != "move_left"):
				get_node("AnimationPlayer").set_current_animation("move_left")
		else:
			moving = false
			if(get_node("AnimationPlayer").get_current_animation() != "dance"):
				get_node("AnimationPlayer").set_current_animation("dance")
	