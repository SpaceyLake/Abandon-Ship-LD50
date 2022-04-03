extends StaticBody2D

signal _win()

export(NodePath) var _door_path
onready var _door = get_node(_door_path)

func _ready():
	add_to_group("EscapePodControl")

func _interact():
	_door.close()
	emit_signal("_win")

func _stop_interaction():
	pass
