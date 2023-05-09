extends Node

export var enemy_scene: PackedScene
onready var player = $Player
var enemy_count = 0
export var max_enemies = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$EnemiesTimer.start()
	player.initialize(self, self)

# Called every time the timer times out.
func _on_EnemiesTimer_timeout():
	if enemy_count >= max_enemies:
		return
	var enemy = enemy_scene.instance()
	enemy.set_values(player)
	
	var enemy_spawn_location = get_node("EnemiesPath/EnemiesPathLocation")
	enemy_spawn_location.offset = randi()
	enemy.position = enemy_spawn_location.position
	add_child(enemy)
	enemy_count+=1
