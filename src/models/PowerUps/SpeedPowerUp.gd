extends PowerUp

class_name SpeedPowerUp

func applyPowerUp(player, duration, strength):
	player.increaseSpeed(duration, strength)
	
