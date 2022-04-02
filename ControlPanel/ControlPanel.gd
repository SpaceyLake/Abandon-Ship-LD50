extends StaticBody2D

export(NodePath) var _door_path
onready var _door = get_node(_door_path)

func _interact():
	if _door.get_is_open():
		print("Close")
		_door.close()
	else:
		print("Open")
		_door.open()
