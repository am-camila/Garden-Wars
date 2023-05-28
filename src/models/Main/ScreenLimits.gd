extends Area2D


var screen_size = Vector2()

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	for child in get_children():
		if child.position.x < 0:
			child.position.x = 0
		if child.position.x > screen_size.x:
			child.position.x = screen_size.x
		if child.position.y < 0:
			child.position.y = 0
		if child.position.y > screen_size.y:
			child.position.y = screen_size.y

func _on_Area2D_body_exited(body):
	var pos = body.position
	if pos.x < 0:
		pos.x = 0
	if pos.x > screen_size.x:
		pos.x = screen_size.x
	if pos.y < 0:
		pos.y = 0
	if pos.y > screen_size.y:
		pos.y = screen_size.y
	body.position = pos
