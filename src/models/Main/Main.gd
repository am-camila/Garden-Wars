extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	$Enemy.set_values($Player)
	$Enemy2.set_values($Player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
