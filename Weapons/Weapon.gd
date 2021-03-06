extends Node2D

export var _bullet : PackedScene
export var _cooldown_time : float = 0.2
onready var _cooldown_timer : Timer = $CooldownTimer
onready var _mussle : Node2D = $Mussle

func _fire(direction : Vector2):
	if _cooldown_timer.time_left <= 0:
		_cooldown_timer.start(_cooldown_time)
		var _bullet_instance = Global.instance_node(_bullet, _mussle.global_position, Global._node_creation_parent)
		_bullet_instance._fire(direction)

func _set_animation(idle : bool, dir : Vector2):
	if dir.y < 0:
		$Mussle.position = Vector2(0, -12)
		if idle:
			$AnimationPlayer.play("Idle Up")
		else:
			$AnimationPlayer.play("Walk Up")
	elif dir.y > 0:
		$Mussle.position = Vector2(3, 11)
		if idle:
			$AnimationPlayer.play("Idle Down")
		else:
			$AnimationPlayer.play("Walk Down")
	else:
		$Mussle.position = Vector2(12, 0)
		if idle:
			$AnimationPlayer.play("Idle Side")
		else:
			$AnimationPlayer.play("Walk Side")

func _set_right(right : bool):
	scale.x = (2*int(right))-1
