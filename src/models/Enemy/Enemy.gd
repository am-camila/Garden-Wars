extends KinematicBody2D

class_name Enemy

var player
var max_health


export var speed = 200
export var health = 50
export var damage = 25
export var powerupChance: float
export (PackedScene) var speed_power_up
export (PackedScene) var hit_power_up
export (PackedScene) var shield_power_up
export (PackedScene) var life_power_up
onready var powerUps: Array  = [speed_power_up,hit_power_up,life_power_up]


func _ready():
	$LifeBar.max_value = health
	max_health = health
	$LifeBar.hide()
	$LifeBar.value = max_health
	$AnimatedSprite.play("walk")

func set_values(player):
	self.player = player

func _process(delta):
	if player == null:
		return
		
	var direction = (player.position - position).normalized()
	var movement = direction * speed
	#if speed < 3000:
	#	speed += delta * speed
	move_and_slide(movement)


func _on_Area2D_body_entered(body):
	if body is Projectile:
		max_health -= player.damage
		$LifeBar.value = max_health
		$LifeBar.show()
		GLOBALS.emit_signal("hit")
		if max_health < 1:
			GLOBALS.emit_signal("enemy_die")
			if randf()*100 <= powerupChance:
				var powerUp = random_powerUp()
				powerUp.position = position
				get_parent().add_child(powerUp)
				GLOBALS.emit_signal("spawn_powerup")
			queue_free()


func random_powerUp():
	if powerUps.size() > 0:
		var index = randi() % powerUps.size()
		var rand_powerUp = powerUps[index].instance()
		return rand_powerUp
