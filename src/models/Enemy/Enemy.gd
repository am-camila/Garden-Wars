extends KinematicBody2D


var player
export var speed = 3500

func set_values(player):
	self.player = player

func _process(delta):
	if player == null:
		return
		
	var direction = (player.position - position).normalized()
	var movement = direction * speed * delta
	#if speed < 3000:
	#	speed += delta * speed
	move_and_slide(movement)
