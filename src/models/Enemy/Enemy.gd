extends Node2D

class_name Enemy

var player
var max_health

#Variables de colision
var hayColision = false
var areasDentro = 0
var parientes = []
var spawn_point :Vector2
var collition_count = 0
var can_take_damage = true

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
	$AnimatedSprite.material.set_shader_param("flash_modifier",0.0)
	$LifeBar.max_value = health
	max_health = health
	$LifeBar.hide()
	$LifeBar.value = max_health

func set_values(player, spawn):
	self.player = player
	spawn_point = spawn

func _process(delta):
	if player == null:
		return
		
	var direction_to_target = (player.position - position).normalized()
	var movement_to_target = direction_to_target * speed * delta
	position += movement_to_target
	$AnimatedSprite.play("walk")
	if direction_to_target.x < 0:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true

func _on_Area2D_body_entered(body):
	if body is Projectile:
		max_health -= player.damage
		hit_color()
		speed = speed * 0.55
		$LifeBar.value = max_health
		$Hit.play()
		GLOBALS.emit_signal("hit")
		if max_health < 1:
			GLOBALS.emit_signal("enemy_die")
			
			if randf()*100 <= powerupChance:
				var powerUp = random_powerUp()
				powerUp.position = position
				get_parent().add_child(powerUp)
				GLOBALS.emit_signal("spawn_powerup")
			$DieTimer.start()


func hit_color():
	$AnimatedSprite.material.set_shader_param("flash_modifier",0.7)
	$FlashTimer.start()

func random_powerUp():
	if powerUps.size() > 0:
		var index = randi() % powerUps.size()
		var rand_powerUp = powerUps[index].instance()
		return rand_powerUp



func _on_CollisionParents_area_entered(area):
	parientes.append(area)
	areasDentro += 1
	if areasDentro > 0:
		for elem in parientes:
			var direction:Vector2 = global_position - elem.global_position
			position += direction.normalized() * 3



func _on_CollisionParents_area_exited(area):
	areasDentro -= 1
	var find_p = parientes.find(area)
	if find_p != -1:
		parientes.remove(find_p)


func _on_FlashTimer_timeout():
	$AnimatedSprite.material.set_shader_param("flash_modifier",0)




func _on_DieTimer_timeout():
	queue_free()
