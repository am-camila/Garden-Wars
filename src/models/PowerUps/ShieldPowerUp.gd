extends PowerUp

class_name ShieldPowerUp

func _ready():
	pass 
	
func applyPowerUp(player, duration, strength):
	queue_free()
	player.powerUp_timer.wait_time = duration
	player.powerUp_timer.start()
	player.powerUp_active = true

	if (player.powerUp_active):
		player.restore_normal_attributes()

	print("applying powerUp: Shield active for "+str(duration))
	player.activate_shield(duration)
	player.powerUp_timer.start()
	print("applying powerup - shield")


func _on_Area2D_body_entered(body):
		print("shield: choqué con un nodo: "+str(body))
		if body is Player:
			applyPowerUp(body,duration,strength)
			queue_free()


func _on_SpawnTimer_timeout():
	queue_free()
