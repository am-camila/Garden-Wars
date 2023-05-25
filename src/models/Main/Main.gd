extends Node

export var enemy_scene: PackedScene
onready var player = $Player


#lista que contiene a todos los enemigos generados
var enemies = []

var enemy_count = 0
export var max_enemies = 10


export var time_per_wave = 10


var sleep_global_time = 5

#segundos de espera entre oleada
var sleep_wave_timer = 5

#oleada actual
var current_wave = 1

#tiempo que dura la oleada
var time_wave

#tiempo actual de oleada
var time_current_wave = 0


func _ready():
	SAVE.load_data()
	randomize()
	$ExpBar.hide()



func new_game():
	#$ExpBar.show()
	time_wave = time_per_wave + (current_wave * time_per_wave * 0.5)
	player.initialize(self, self)
	see_wave_text()	
	$HUD.show_message("Get Ready")



# Timer que spawnea los enemigos en cada oleada
func _on_EnemiesTimer_timeout():
	if time_wave < 1:
		$TimerText.hide()
		$PlayWaveTimer.stop()
		current_wave +=1
		time_wave = time_per_wave + (current_wave * time_per_wave * 0.5)
		deleteEnemies()
		see_wave_text()
		return
	var enemy = enemy_scene.instance()
	enemy.set_values(player)
	enemies.append(enemy)
	
	var enemy_spawn_location = get_node("EnemiesPath/EnemiesPathLocation")
	enemy_spawn_location.offset = randi()
	enemy.position = enemy_spawn_location.position
	add_child(enemy)
	enemy_count+=1
	time_current_wave+=1
	time_wave -=1
	$TimerText.text = "Next Wave in: " + str(time_wave)
	

#Timer que ejecuta cada oleada
func _on_PlayWaveTimer_timeout():
	if player.health <= 1:
		return
	$TimerText.show()
	$TimerText.text = "Next Wave in: " + str(time_wave)
	$EnemiesTimer.start()


#Muestra el texto en pantalla previo a iniciar la oleada
func see_wave_text():	
	$NumberWaveTimer/NumberWave.show()
	$NumberWaveTimer/NumberWave.text = "Wave #"+str(current_wave)+" start in "+str(sleep_wave_timer)
	$NumberWaveTimer.start()

#Timer que disminuye el tiempo que muestra el texto previo a iniciar la oleada
func _on_NumberWaveTimer_timeout():
	if sleep_wave_timer <= 1:
		$NumberWaveTimer.stop()
		$NumberWaveTimer/NumberWave.hide()
		$PlayWaveTimer.start()
		sleep_wave_timer = sleep_global_time +1
	sleep_wave_timer -= 1
	$NumberWaveTimer/NumberWave.text = "Wave #"+str(current_wave)+" start in "+str(sleep_wave_timer)


func deleteEnemies():
	GLOBALS.emit_signal("wave_end")
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	enemies.clear()
	$EnemiesTimer.stop()

