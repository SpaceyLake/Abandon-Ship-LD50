extends StaticBody2D

export(NodePath) var _door_path
onready var _door = get_node(_door_path)

func _ready():
	add_to_group("ControlPanels")

func _interact():
	if _door.get_is_open():
		_door.close()
	else:
		_door.open()

func _stop_interaction():
	pass
