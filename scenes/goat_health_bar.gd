extends Sprite

onready var min_scale = 0.12
onready var max_scale = 1.88

onready var current_percentage = 0.5

func set_scale(percentage):
	var new_scale = min_scale + (max_scale-min_scale)*(percentage)
	if(new_scale <= min_scale):
		new_scale = min_scale
		emit_signal("bottom_percentage")
	elif new_scale >= max_scale:
		new_scale = max_scale
		emit_signal("top_percentage")
	current_percentage = (new_scale-min_scale) / (max_scale-min_scale)
	get_node("background").set_scale(Vector2(new_scale, 1.0))

func set_scale_relative(percentage):
	percentage += current_percentage
	var new_scale = min_scale + (max_scale-min_scale)*(percentage)
	if(new_scale <= min_scale):
		new_scale = min_scale
		emit_signal("bottom_percentage")
	elif new_scale >= max_scale:
		new_scale = max_scale
		emit_signal("top_percentage")
	current_percentage = (new_scale-min_scale) / (max_scale-min_scale)
	get_node("background").set_scale(Vector2(new_scale, 1.0))

func get_percentage():
	return current_percentage

func _ready():
	# signals for min and max
	add_user_signal("top_percentage")
	add_user_signal("bottom_percentage")
	# if scene is running as root, debug
	var root = get_node("/root")
	if(root.get_child(root.get_child_count()-1) == self):
		set_fixed_process(true)

func _fixed_process(delta):
	if Input.is_mouse_button_pressed(1):
		set_scale_relative(0.01)
	else:
		set_scale_relative(-0.01)
