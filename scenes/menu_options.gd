tool
extends Control

# ========= Variables ==========
export(String, MULTILINE) var options = "" setget set_options # The options on the menu, separated by line
export(int, "Horizontal", "Vertical") var orientation = 0 setget set_orientation # Horizontal or Vertical menu
export(int) var offset = 0 setget set_offset # Offset between options
export(Font) var options_font = null setget set_font # Menu font
export(int, "Number", "String") var signal_argument = 0 # Whether you receive the number of the option choosen or the string
export(int) var initial_option = 0 setget set_cursor_option # Cursor starting position
export(int, "Left", "Top", "Right", "Bottom") var cursor_side = 0 setget set_cursor_side # Which side the cursor will appear on the options
export(int) var cursor_offset = 0 setget set_cursor_offset

export(bool) var enable_keyboard = true setget set_keyboard # Whether the menu is on or off.
export(bool) var enable_mouse = true setget set_mouse # Whether you can click options with the mouse
export(float) var blinking_cursor_rate = 0.0 setget set_blinking_cursor_rate# How many seconds for the cursor to blink (0 means he doesn't blink)
export(Color) var cursor_color = Color(1.0,1.0,1.0,1.0) setget set_cursor_color
export(Color) var option_enabled_color = Color(1.0,1.0,1.0,1.0) setget set_enabled_color
export(Color) var option_disabled_color = Color(0.4,0.4,0.4,1.0) setget set_disabled_color

var _enabled_options = []
var _current_option = 0
var _cursor_timer = 0.0
var _cursor = add_child(Label.new())

# ========= 'Public' methods ==========
func set_options(new_options):
	options = new_options
	
	_clear_node()
	_create_options_nodes(_parse_options())
	set_cursor_option(initial_option)
	_update_font()
	_enabled_options.clear()
	for i in get_children():
		_enabled_options.append(1)

func set_orientation(new_orientation):
	orientation = new_orientation
	_position_nodes()

func set_offset(new_offset):
	offset = new_offset
	_position_nodes()

func set_font(new_font):
	options_font = new_font
	_update_font()
	_position_nodes()
	_update_cursor_position()

func set_cursor_option(new_initial_option):
	_current_option = (abs(new_initial_option) % get_child_count())
	_set_cursor(_current_option)
	_update_cursor_position()

func set_keyboard(b):
	enable_keyboard = b

func set_mouse(b):
	enable_mouse = b

func set_blinking_cursor_rate(n):
	blinking_cursor_rate = n

func set_cursor_offset(n):
	cursor_offset = n

func set_cursor_color(new_cursor_color):
	cursor_color = new_cursor_color
	_cursor.add_color_override("font_color", new_cursor_color)

func set_enabled_color(new_enabled_color):
	option_enabled_color = new_enabled_color
	_update_color()

func set_disabled_color(new_disabled_color):
	option_disabled_color = new_disabled_color
	_update_color()

func override_options(dict):
	if dict.has("options"):
		set_options(dict["options"])
	if dict.has("orientation"):
		set_orientation(dict["orientation"])
	if dict.has("offset"):
		set_offset(dict["offset"])
	if dict.has("font"):
		set_font(dict["font"])

func set_option(o,b):
	var child_num = o
	if typeof(o) == TYPE_STRING:
		for i in range(0,get_children().size()):
			if get_child(i).get_text() == o:
				child_num = i
	if b:
		_enabled_options[o] = 1
	else:
		_enabled_options[o] = 0
	_update_color()

func set_cursor_side(s):
	cursor_side = s
	_update_cursor_position()

# ========= Internal functions ==========

func _clear_options():
	for i in get_children():
		if i == _cursor:
			continue
		i.free()

func _create_options():
	_clear_options()
	

func _reposition_options():
	count = 0
	manual_offset = 0
	for i in get_children():
		if i == _cursor:
			continue
		if orientation == 0:
			i.set_pos(Vector2(((offset)*count) + manual_offset, 0))
			manual_offset += i.get_font("font").get_string_size(i.get_text()).x
		elif orientation == 1:
			i.set_pos(Vector2(0, (offset)*count + manual_offset))
			manual_offset += i.get_font("font").get_string_size(i.get_text()).y
		count += 1

func _ready():
	if !(get_tree().is_editor_hint()):
		set_fixed_process(true)
		set_process_input(true)
		# Option and cursor
		add_user_signal("option_selected")

func _fixed_process(delta):
	# Blinking
	if(blinking_cursor_rate > 0):
		_cursor_timer += delta
		if _cursor_timer > blinking_cursor_rate:
			_cursor_timer = 0.0
			_cursor.set_lines_skipped((_cursor.get_lines_skipped()+1)%2)
	pass

func _input(event):
	if (event.type == InputEvent.KEY and event.pressed):
		if event.scancode == KEY_UP:
			if(orientation == 1):
				set_cursor_option(_current_option + get_child_count() - 1)
		if event.scancode == KEY_DOWN:
			if(orientation == 1):
				set_cursor_option(_current_option + 1)
		if event.scancode == KEY_RIGHT:
			if(orientation == 0):
				set_cursor_option(_current_option + 1)
		if event.scancode == KEY_LEFT:
			if(orientation == 0):
				set_cursor_option(_current_option + get_child_count() - 1)
		if event.scancode == KEY_ENTER:
			if(signal_argument == 0):
				emit_signal("option_selected", _current_option)
			elif(signal_argument == 1):
				emit_signal("option_selected", get_child(_current_option).get_text())
		_cursor_timer = 0.0
		_cursor.set_lines_skipped(0)