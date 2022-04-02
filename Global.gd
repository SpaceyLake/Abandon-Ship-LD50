extends Node

var _player : KinematicBody2D = null

var _node_creation_parent = null

func instance_node(node, location, parent):
	if parent == null: return null
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance
