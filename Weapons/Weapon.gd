extends Node2D

export var bullet : PackedScene
onready var mussle = $Mussle

func _fire(direction : Vector2):
	var bullet_instance = Global.instance_node(bullet, mussle.global_position, Global._node_creation_parent)
	bullet_instance._fire(direction)
	
