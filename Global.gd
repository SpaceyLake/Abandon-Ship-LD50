extends Node

var _player : KinematicBody2D = null

var _UI : CanvasLayer = null

var _node_creation_parent : Node2D = null

func instance_node_deferred(node, location, parent):
	if parent == null: return null
	var node_instance = node.instance()
	parent.call_deferred("add_child", node_instance)
	node_instance.global_position = location
	return node_instance
	
func instance_node(node, location, parent):
	if parent == null: return null
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance

func instance_control_node(node, location, parent):
	if parent == null: return null
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.rect_global_position = location
	return node_instance
