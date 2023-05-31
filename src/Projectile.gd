extends KinematicBody2D

class_name Projectile

onready var lifetime_timer = $LifetimeTimer

export (float) var VELOCITY:float = 400.0

var direction:Vector2

func initialize(container, spawn_position:Vector2, direction2:Vector2):
	container.add_child(self)
	self.direction = direction2
	global_position = spawn_position
	lifetime_timer.connect("timeout", self, "_on_lifetime_timer_timeout")
	lifetime_timer.start()


func _physics_process(delta):
	position += direction * VELOCITY * delta

#	var visible_rect:Rect2 = get_viewport().get_visible_rect()
#	if !visible_rect.has_point(global_position):
#		_remove()

# Si supero una cantidad de tiempo de vida
func _on_lifetime_timer_timeout():
	_remove()

func _remove():	
	get_parent().remove_child(self)
	queue_free()
	
