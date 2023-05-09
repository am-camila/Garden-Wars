extends KinematicBody2D

class_name Enemy

var player
var max_health

export var speed = 3500
export var health = 100

func _ready():
	max_health = health


func set_values(player):
	self.player = player



func _process(delta):
	var direction = (player.position - position).normalized()
	var movement = direction * speed * delta
	#if speed < 3000:
	#	speed += delta * speed
	move_and_slide(movement)



func kill_enemy( damage):
	max_health -= damage
	if max_health < 1:
		queue_free()
