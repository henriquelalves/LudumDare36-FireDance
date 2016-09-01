
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_pos(get_global_mouse_pos())
	set_fixed_process(true)
	add_to_group("player")
	get_node("/root/global").player_ref = self
	pass

func _fixed_process(delta):
	set_pos(get_global_mouse_pos())
