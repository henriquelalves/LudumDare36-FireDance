
extends KinematicBody2D

func _ready():
	add_to_group("fire")
	get_node("AnimationPlayer").play("fire")
	pass