extends PowerUp

class_name SpeedPowerUp

func applyPowerUp(player, duration, strength):
	print("applying powerUp: Speed for "+str(duration) +"and with strength "+ str(strength))
	player.increaseSpeed(duration, strength)
	
