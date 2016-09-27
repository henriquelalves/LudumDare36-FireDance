
extends Node2D

func blink():
	var new_pos = Vector2((randi()%9)*32 + 48,(randi()%7)*32 + 80)
	set_pos(new_pos)

func _ready():
	blink()
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if(get_node("Area2D").get_overlapping_bodies().size() > 0):
		for b in get_node("Area2D").get_overlapping_bodies():
			if b.is_in_group("player"):
				global.score += 5000
		blink()
