extends Node2D

export var speed = 400
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
