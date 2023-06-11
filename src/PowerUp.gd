extends Node2D

class_name PowerUp

export var duration: float = 5.0
export var strength: float = 1.30

onready var timer = $SpawnTimer


func _ready():
	pass 

func applyPowerUp(player:Player, duration:float, strength:float):
	queue_free()
	$PickUp.play()
	player.powerUp_timer.wait_time = duration
	player.powerUp_timer.start()
	player.powerUp_active = true

func _on_Node2D_body_entered(body):
	if body is Player:
		applyPowerUp(body,duration,strength)
		queue_free()

#Si el player no toma el powerup dentro de un determinado tiempo, se destruye.
func _on_SpawnTimer_timeout():
	queue_free()
