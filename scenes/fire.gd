
extends KinematicBody2D

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if is_colliding():
		var collider = get_collider()
		print(collider)
		if collider.is_in_group("goats"):
			collider._bump()
			print("oi")


