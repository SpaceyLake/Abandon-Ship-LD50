extends Node2D


func _ready():
	Global._node_creation_parent = self

func _exit_tree():
	Global._node_creation_parent = null
