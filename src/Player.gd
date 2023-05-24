extends Node2D

class_name Player

export var speed = 400
export var health = 100
export var damage = 25


# Variables atributos del player
var max_health
var can_take_damage = true


onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer


export (PackedScene) var projectile_scene


# Variables para enemigos y disparar
var enemies = []
var target:KinematicBody2D
var projectile:Sprite
var projectile_container



# Called when the node enters the scene tree for the first time.
func _ready():
	fire_timer.connect("timeout", self, "fire_at_enemy")
	GLOBALS.connect("hit",self,"_on_hit_enemy")
	GLOBALS.connect("wave_end",self,"_on_wave_end")
	max_health = health
	$LifePoints.max_value = health
	$LifePoints.hide()
	$LifePoints.value = max_health


func initialize(container, projectile_container):
	self.projectile_container = projectile_container


func fire_at_enemy():
	if enemies.size() == 0:
		fire_timer.stop()
	if enemies.size() > 0:
		var enem = enemies.front()
		if !is_instance_valid(enem):
			if enemies.size() > 0:
				enemies.remove(0)
				if enemies.size() > 0:
					enem = enemies.front()
		else:
			var proj_instance = projectile_scene.instance()
			var num_rand = randi() % 2
			if num_rand:
				$Fire1Audio.play()
			else:
				$Fire2Audio.play()
			proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(enem.global_position))	


func _on_wave_end():
	$Fire1Audio.stop()
	$Fire2Audio.stop()

func _on_hit_enemy():
	$Fire1Audio.stop()
	$Fire2Audio.stop()

func _process(delta):
	var player_position = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		player_position.x += 1
	if Input.is_action_pressed("move_left"):
		player_position.x -= 1
	if Input.is_action_pressed("move_down"):
		player_position.y += 1
	if Input.is_action_pressed("move_up"):
		player_position.y -= 1
		
	if player_position.length() > 0:
		player_position = player_position.normalized() * speed 
			
	position += player_position * delta



func _on_FireArea_body_entered(body):
	if body is Enemy:
		enemies.append(body)
		fire_timer.start()



func _on_HitArea_body_entered(body):
	if body is Enemy:
		if can_take_damage:
			max_health -= body.damage
			$LifePoints.value = max_health
			$LifePoints.show()
			can_take_damage = false
			$LifeTimer.start()
			if max_health < 1:
				print("mori")
				#get_tree().paused = true


func _on_LifeTimer_timeout():
	can_take_damage = true
