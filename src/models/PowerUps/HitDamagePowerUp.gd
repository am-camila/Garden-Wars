extends PowerUp

class_name HitDamagePowerUp

func _ready():
	pass 
	
func applyPowerUp(player, duration, strength):
	queue_free()
	player.powerUp_timer.wait_time = duration
	player.powerUp_timer.start()
	player.powerUp_active = true

	if (player.powerUp_active):
		player.restore_normal_attributes()

	print("applying powerUp: Hit Damage for "+str(duration) +"and with strength "+ str(strength))
	player.increaseDamage(duration, strength)
	player.powerUp_timer.start()
	print("applying powerup - damage: "+ str(player.damage))


func _on_Area2D_body_entered(body):
		print("choqué con un nodo: "+str(body))
		if body is Player:
			applyPowerUp(body,duration,strength)
			queue_free()


func _on_SpawnTimer_timeout():
	queue_free()
