extends Control

var _menu_items = Array()
var _menu_length = 0
var _menu_current = 0
export(NodePath) var _selector_path
onready var _selector = get_node(_selector_path)
export(Array, String) var _scenes

func _ready():
	_menu_items = $Background/Menu.get_children()
	_menu_length = _menu_items.size()

func _process(_delta):
	if Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("fire_down"):
		_menu_current += 1
		if _menu_current >= _menu_length: _menu_current -= _menu_length
	if Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("fire_up"):
		_menu_current -= 1
		if _menu_current < 0: _menu_current += _menu_length
	_selector.rect_position = _menu_items[_menu_current].rect_position
	if Input.is_action_just_pressed("interact"):
		get_tree().change_scene(_scenes[_menu_current])
	if Input.is_action_just_pressed("escape"): get_tree().quit()
