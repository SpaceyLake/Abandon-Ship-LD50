extends Node2D

export var bullet : PackedScene
onready var mussle = $Mussle

func _fire(direction : Vector2):
	var bullet_instance = Global.instance_node(bullet, mussle.global_position, Global._node_creation_parent)
	bullet_instance._fire(direction)

func _set_animation(idle : bool, dir : Vector2):
	if dir.y < 0:
		if idle:
			$AnimationPlayer.play("Idle Up")
		else:
			$AnimationPlayer.play("Walk Up")
	elif dir.y > 0:
		if idle:
			$AnimationPlayer.play("Idle Down")
		else:
			$AnimationPlayer.play("Walk Down")
	else:
		if idle:
			$AnimationPlayer.play("Idle Side")
		else:
			$AnimationPlayer.play("Walk Side")

func _set_right(right : bool):
	scale.x = (2*int(right))-1
