extends KinematicBody2D

var speed = 200

func _ready():
	print("Hero Loaded! Yay!")

func _process(delta):
	if Input.is_action_pressed('ui_right'):
		$Sprite.play("walk-right")
		position.x += (speed * delta)
	elif Input.is_action_pressed('ui_left'):
		$Sprite.play("walk-left")
		position.x -= (speed * delta)
	elif Input.is_action_pressed('ui_up'):
		$Sprite.play("walk-up")
		position.y -= (speed * delta)
	elif Input.is_action_pressed('ui_down'):
		$Sprite.play("walk-down")
		position.y += (speed * delta)
	else:
		$Sprite.stop()