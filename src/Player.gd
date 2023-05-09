extends Node2D

export var speed = 400

onready var fire_position = $FirePosition
onready var fire_timer = $FireTimer

export (PackedScene) var projectile_scene

var target:KinematicBody2D
var projectile:Sprite
var projectile_container


# Called when the node enters the scene tree for the first time.
func _ready():
	fire_timer.connect("timeout", self, "fire_at_enemy")


func initialize(container, player_pos, projectile_container):
	container.add_child(self)
	#global_position = player_pos
	self.projectile_container = projectile_container


func fire_at_enemy():
	var proj_instance = projectile_scene.instance()
	proj_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position))


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		target = body
		fire_timer.start()


func _on_FireArea_body_exited(body):
	fire_timer.stop()
