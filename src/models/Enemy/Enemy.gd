extends KinematicBody2D


var player
export var speed = 3500

func _ready():
	pass # Replace with function body.


func set_values(player):
	self.player = player



func _process(delta):
	var direction = (player.position - position).normalized()
	var movement = direction * speed * delta
	#if speed < 3000:
	#	speed += delta * speed
	move_and_slide(movement)
