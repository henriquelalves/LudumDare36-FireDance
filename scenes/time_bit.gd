
extends Sprite

var is_on = true setget set_bit, get_bit

var texture_on = load("res://assets/time_bit_on.png")
var texture_off = load("res://assets/time_bit_off.png")

func set_bit(b):
	if(b != is_on):
		if(b == true):
			set_texture(texture_on)
		else:
			set_texture(texture_off)
		is_on = b

func get_bit():
	return is_on

func _ready():
	pass

