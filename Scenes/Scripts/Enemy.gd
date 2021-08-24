extends KinematicBody2D

var target: KinematicBody2D

var speed = 200
var pos_start:Vector2
var pos_end:Vector2
var pos_last:Vector2

enum { GUARD, FOLLOW, BACK }
var state: int = GUARD

var motion = Vector2()
var move_right=true
var cur_pos:Vector2

func _ready():
	pos_start = global_position
	cur_pos   = global_position
	pos_end = Vector2((pos_start.x +30), pos_start.y)

func _process(delta):	
	# States
	match state:
		GUARD:
			_guard()
		FOLLOW:
			_follow()
		BACK:
			_back()

	motion = move_and_slide(motion)
	global_position.x = round(global_position.x)
	global_position.y = round(global_position.y)
	
	_animate()

# animation control
func _animate():
	# Animation Definition
	if cur_pos.x < global_position.x:
		$Sprite.play('walk-right')
	else:
		$Sprite.play('walk-left')
	cur_pos = global_position

# states
func _guard():
	if move_right:
		motion.x = speed
	else:
		motion.x = -speed

	if move_right and global_position.x > (pos_start.x + pos_end.x):
		$Sprite.play('walk-left')
		move_right=false
	elif not move_right and global_position.x < pos_start.x:
		$Sprite.play('walk-right')
		move_right=true

func _follow():
	motion = Vector2.ZERO
	motion = ( target.global_position - global_position ).normalized() * speed

func _back():
	motion = Vector2.ZERO
	motion = ( pos_last - global_position ).normalized() * speed

	if global_position.distance_to(pos_last) <= 2:
		global_position = pos_last
		motion = Vector2.ZERO
		state = GUARD

func _on_VisionArea_body_entered(body):
	if body.is_in_group("Hero"):
		if state == GUARD:
			pos_last = global_position

		target = body
		state = FOLLOW
		

func _on_VisionArea_body_exited(body):
	if body.is_in_group("Hero"):
		target = null
		if state == FOLLOW:
			state = BACK
