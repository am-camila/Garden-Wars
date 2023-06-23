extends PowerUp

class_name LifePowerUp

func _ready():
	strength = 20

func applyPowerUp(player, duration, strength):
	player.increaseHealth(strength)


func _on_Area2D_body_entered(body):
	if body is Player:
		applyPowerUp(body,duration,strength)
		queue_free()
			
func _on_SpawnTimer_timeout():
	queue_free()
