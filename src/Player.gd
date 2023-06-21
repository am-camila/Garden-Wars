extends KinematicBody2D

class_name Player

export var normal_speed = 500
export var normal_damage = 25
export var health = 100


var velocity : Vector2
var direction : Vector2


# Variables atributos del player
var max_health
var can_take_damage = true
var one_petal: Texture
var two_petals: Texture
var three_petals: Texture
var four_petals: Texture
var five_petals: Texture


onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer
onready var powerUp_timer = $PowerUpTimer
onready var sprite = $AnimatedSprite
onready var flowerSprite = get_node("SpriteFlower")
onready var animated_sprite = get_node("AnimatedSprite")

export (PackedScene) var projectile_scene


# Variables para enemigos y disparar
var enemies = []
var enemies_count = 0
var target:Area2D
var near :float = 1000.0
var projectile:Sprite
var projectile_container
var powerUp_active = false
var speed
var damage
var hit_timer
var flash = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	max_health = health
	reset_hit_count()
	fire_timer.connect("timeout", self, "fire_at_enemy")
	GLOBALS.connect("hit",self,"_on_hit_enemy")
	GLOBALS.connect("wave_end",self,"_on_wave_end")
	speed = normal_speed
	damage = normal_damage
	sprite.material.set_shader_param("flash_modifier",0 )
	one_petal = load("res://assets/plant/flower/Sprite-flower-1petal.png")
	two_petals = load("res://assets/plant/flower/Sprite-flower-2petals.png")
	three_petals = load("res://assets/plant/flower/Sprite-flower-3petals.png")
	four_petals = load("res://assets/plant/flower/Sprite-flower-4petals.png")
	five_petals = load("res://assets/plant/flower/Sprite-flower-5petals.png")
	changeFlowerSprite()
	$AnimatedSprite.play("idle")


func _process(delta):
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("special_attack"):
		if max_health > 25:
			_special_fire()
			max_health -= 25
			changeFlowerSprite()
			return
		if max_health == 25:
			$CancelSpecialFire.play()
		
	check_health()


func initialize(container, projectile_container):
	self.projectile_container = projectile_container


func fire_at_enemy():
	if enemies_count == 0:
		fire_timer.stop()
	if enemies.size() > 0:
		near = 1000.0
		for elem in enemies:
			if is_instance_valid(elem):
				var enemy_distance = position.distance_to(elem.position)
				if enemy_distance < near:
					near = enemy_distance
					target = elem
	if is_instance_valid(target):
		var proj_instance = projectile_scene.instance()
		var num_rand = randi() % 2
		if num_rand:
			$Fire1Audio.play()
		else:
			$Fire2Audio.play()
		proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position))	


func _on_wave_end():
	$Fire1Audio.stop()
	$Fire2Audio.stop()

func _on_hit_enemy():
	$Fire1Audio.stop()
	$Fire2Audio.stop()



func _unhandled_input(event):
	direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		
		direction.x = 1
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		direction.x = -1
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = true
	if Input.is_action_pressed("move_down"):
		direction.y = 1
		$AnimatedSprite.play("walk")
	if Input.is_action_pressed("move_up"):
		direction.y = -1
		$AnimatedSprite.play("walk")
	if Input.is_action_just_released("move_left") || Input.is_action_just_released("move_right"):
		$AnimatedSprite.stop()
			
	direction = direction.normalized()
	



func check_health():
	if max_health < 1:
		GLOBALS.emit_signal("player_die")
		return


func _on_LifeTimer_timeout():
	can_take_damage = true
	$LifeTimer.stop()


func _special_fire():
			var proj_N = projectile_scene.instance()
			var proj_S = projectile_scene.instance()
			var proj_E = projectile_scene.instance()
			var proj_O = projectile_scene.instance()
			
			proj_N.set_scale(Vector2(4,4))
			proj_S.set_scale(Vector2(4,4))
			proj_E.set_scale(Vector2(4,4))
			proj_O.set_scale(Vector2(4,4))	
			
			var glob = fire_position.global_position
			proj_N.initialize(projectile_container, fire_position.global_position, glob.direction_to(fire_position.global_position+(Vector2(0,10))))
			proj_S.initialize(projectile_container, fire_position.global_position, glob.direction_to(fire_position.global_position+(Vector2(0,-10))))
			proj_E.initialize(projectile_container, fire_position.global_position, glob.direction_to(fire_position.global_position+(Vector2(10,0))))
			proj_O.initialize(projectile_container, fire_position.global_position, glob.direction_to(fire_position.global_position+(Vector2(-10,0))))
			$SpecialFire.play()
	



func increaseSpeed(duration, strength):
	$PickUp.play()
	$PowerUpTimer.wait_time = duration
	if speed == normal_speed:
		speed = speed * strength

func increaseDamage(duration, strength):
	$PickUp.play()
	$PowerUpTimer.wait_time = duration
	if damage == normal_damage:
		damage = damage * strength




func _on_PowerUpTimer_timeout():
	powerUp_active = false
	restore_normal_attributes()

func restore_normal_attributes():
	speed = normal_speed
	damage = normal_damage


func increaseHealth(strength):
	$PickUp.play()
	if max_health < health:
		max_health += strength
		changeFlowerSprite()


func _on_HitArea_area_entered(area):
	if area is Enemy:
		if can_take_damage:
			$AnimatedSprite.play("hit")
			$Hit.play()
			max_health -= 20
			changeFlowerSprite()
			can_take_damage = false
			$LifeTimer.start()
			$HitTimer.start()



func _on_FireArea_area_entered(area):
	if area is Enemy:
		enemies_count += 1
		enemies.append(area)
		fire_timer.start()


func _on_FireArea_area_exited(area):
	var index = enemies.find(area)
	if index >= enemies.size():
		enemies.remove(index)
	enemies_count -= 1


func _on_HitTimer_timeout():
	$Hit.stop()
	if flash > 0:
		flash = 0
	else:
		 flash = 0.7
	sprite.material.set_shader_param("flash_modifier", flash)
	hit_timer -= 1
	if hit_timer == 0:
		$HitTimer.stop()
		reset_hit_count()
		can_take_damage = true


func reset_hit_count():
	hit_timer = 6


func changeFlowerSprite():
	if max_health >= 0 and max_health <= 20:
		$SpriteFlower.position = $FlowerPosition.position
		$SpriteFlower.texture = one_petal
	if max_health >= 21 and max_health <= 40:
		$SpriteFlower.position = $FlowerPosition.position
		$SpriteFlower.texture = two_petals
	if max_health >= 41 and max_health <= 60:
		$SpriteFlower.position = $FlowerPosition.position
		$SpriteFlower.texture = three_petals
	if max_health >= 61 and max_health <= 80:
		$SpriteFlower.position = $FlowerPosition.position
		$SpriteFlower.texture = four_petals
	if max_health >= 81 and max_health <= 100:
		$SpriteFlower.position = $FlowerPosition.position
		$SpriteFlower.texture = five_petals


