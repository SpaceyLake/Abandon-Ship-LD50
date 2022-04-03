extends Control

func _process(delta):
	if Input.is_action_just_pressed("fire_down") or Input.is_action_just_pressed("fire_left") or Input.is_action_just_pressed("fire_right") or Input.is_action_just_pressed("fire_up") or Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_up"):
		get_tree().change_scene("res://MainMenu.tscn")
