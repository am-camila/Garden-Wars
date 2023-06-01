extends Node

export var enemy_scene: PackedScene
onready var player = $Player

var music_on = false

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

var wave_on = true

func _ready():
	SAVE.load_data()
	randomize()
	$HudDatos/ExpBar.hide()
	GLOBALS.connect("enemy_die",self,"_on_enemy_dies")
	GLOBALS.connect("player_die",self,"_on_player_dies")


func new_game():
	#$ExpBar.show()
	time_wave = time_per_wave + (current_wave * time_per_wave * 0.5)
	player.initialize(self, self)
	see_wave_text()	
	$HUD.show_message("Get Ready")



# Timer que spawnea los enemigos en cada oleada
func _on_EnemiesTimer_timeout():
	if wave_on :
		if time_wave < 1:
			$EnemiesTimer.stop()
			$HudDatos/TimerText.hide()
			$HudDatos/PlayWaveTimer.stop()
			current_wave +=1
			time_wave = time_per_wave + (current_wave * time_per_wave * 0.5)
			$HudDatos/WaitEnemyDieTimer.start()
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
		$HudDatos/TimerText.text = "Next Wave in: " + str(time_wave)


#Timer que ejecuta cada oleada
func _on_PlayWaveTimer_timeout():
	if !music_on:
		music_on = !music_on
		$SpringMusicTheme.play()
	if player.health <= 1:
		return
	
	$HudDatos/TimerText.show()
	$HudDatos/TimerText.text = "Next Wave in: " + str(time_wave)
	$EnemiesTimer.start()




#Muestra el texto en pantalla previo a iniciar la oleada
func see_wave_text():
	if enemy_count == 0:
		$HudDatos/NumberWaveTimer/NumberWave.show()
		$HudDatos/NumberWaveTimer/NumberWave.text = "Wave #"+str(current_wave)+" start in "+str(sleep_wave_timer)
		$HudDatos/NumberWaveTimer.start()
		$HudDatos/WaitEnemyDieTimer.stop()

#Timer que disminuye el tiempo que muestra el texto previo a iniciar la oleada
func _on_NumberWaveTimer_timeout():
	if sleep_wave_timer <= 1:
		$HudDatos/NumberWaveTimer.stop()
		$HudDatos/NumberWaveTimer/NumberWave.hide()
		$HudDatos/PlayWaveTimer.start()
		sleep_wave_timer = sleep_global_time +1
	sleep_wave_timer -= 1
	$HudDatos/NumberWaveTimer/NumberWave.text = "Wave #"+str(current_wave)+" start in "+str(sleep_wave_timer)


func deleteEnemies():
	GLOBALS.emit_signal("wave_end")
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	enemies.clear()
	$EnemiesTimer.stop()

func _on_enemy_dies():
	enemy_count -= 1


func _on_WaitEnemyDieTimer_timeout():
	see_wave_text()

func _on_player_dies():
	$SpringMusicTheme.stop()
	Input.action_press("ui_cancel")
