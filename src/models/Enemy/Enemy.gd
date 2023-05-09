extends KinematicBody2D

class_name Enemy

var player
var max_health

export var speed = 3500
export var health = 30
export var damage = 15

func _ready():
	max_health = health
	$TextoVida.hide()
	$TextoVida.text = str(max_health)


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



#func kill_enemy(damage):
#	max_health -= damage
#	if max_health < 1:
#		queue_free()


func _on_Area2D_body_entered(body):
	if body is Projectile:
		print(body)
		max_health -= damage
		$TextoVida.text = str(max_health)
		$TextoVida.show()
		if max_health < 1:
			queue_free()
