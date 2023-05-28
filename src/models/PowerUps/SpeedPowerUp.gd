extends PowerUp

class_name SpeedPowerUp

func applyPowerUp(player, duration, strength):
	print("applying powerUp: Speed for "+duration +"and with strength "+ strength)
	player.increaseSpeed(duration, strength)
	
