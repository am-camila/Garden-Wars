extends KinematicBody2D

class_name Enemy

var player
var max_health

export (PackedScene) var powerUpScene
export var powerupChance: float
export var speed = 3500
export var health = 50
export var damage = 25

func _ready():
	$LifeBar.max_value = health
	max_health = health
	$LifeBar.hide()
	$LifeBar.value = max_health

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



func _on_Area2D_body_entered(body):
	if body is Projectile:
		max_health -= player.damage
		$LifeBar.value = max_health
		$LifeBar.show()
		if max_health < 1:
			#if randf()*100 <= powerupChance:
			var powerUp = powerUpScene.instance()
			powerUp.position = position
			powerUp.connect("collected", self, "_on_powerup_collected")
			get_parent().add_child(powerUp)
			queue_free()


