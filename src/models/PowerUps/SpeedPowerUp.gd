extends PowerUp

class_name SpeedPowerUp

func _ready():
	strength = 1.45

func applyPowerUp(player, duration, strength):
	if player.powerUp_active:
		player.restore_normal_attributes()
		queue_free()
		player.powerUp_timer.wait_time = duration
		player.powerUp_timer.start()
		player.powerUp_active = true

	
	player.increaseSpeed(duration, strength)
	player.powerUp_timer.start()


func _on_Area2D_body_entered(body):
		
		if body is Player:
			applyPowerUp(body,duration,strength)
			queue_free()
			
func _on_SpawnTimer_timeout():
	queue_free()
