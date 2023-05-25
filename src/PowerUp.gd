extends Node2D

signal collected

class_name PowerUp

export var duration: float = 5.0
export var strength: float = 1.30

onready var timer: Timer = $Timer

func _ready():
	#timer.start()
	pass
func applyPowerUp(player, duration, strength):
	pass

#Si el player no toma el powerup dentro de un determinado tiempo, se destruye.
func _on_Timer_timeout():
	#queue_free()
	pass
