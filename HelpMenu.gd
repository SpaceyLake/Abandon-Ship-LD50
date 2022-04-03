extends Control

var _panes = Array()
var _panes_target_pos = Array()
var _pane_length = 0
var _pane_current = 0
export var _scroll_speed : float = 320

onready var _pos_left = $Background/ScrollPane/Points/Left
onready var _pos_center = $Background/ScrollPane/Points/Center
onready var _pos_right = $Background/ScrollPane/Points/Right

func _ready():
	_panes = $Background/ScrollPane/Panes.get_children()
	_pane_length = _panes.size()
	for p in _panes:
		_panes_target_pos.push_front(_pos_right.global_position)
		p.rect_position = _pos_right.global_position
	
	_panes[0].rect_position = _pos_center.global_position
	_panes_target_pos[0] = _pos_center.global_position

func _process(delta):
	var i = 0
	for p in _panes:
		p.rect_position = p.rect_position.move_toward(_panes_target_pos[i], _scroll_speed * delta)
		i += 1
	if _panes[_pane_current].rect_position == _panes_target_pos[_pane_current]:
		if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("fire_left"):
			if _pane_current <= 0: get_tree().change_scene("res://MainMenu.tscn")
			_panes_target_pos[_pane_current] = _pos_right.global_position
			_pane_current -= 1
			_panes_target_pos[_pane_current] = _pos_center.global_position
		if Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("fire_right"):
			if _pane_current+1 < _pane_length: 
				_panes_target_pos[_pane_current] = _pos_left.global_position
				_pane_current += 1
				_panes_target_pos[_pane_current] = _pos_center.global_position
