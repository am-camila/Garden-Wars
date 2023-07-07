extends Node

export var enemy_ant_scene: PackedScene
export var enemy_snail_scene: PackedScene
export var enemy_beetle_scene: PackedScene

onready var player = $Player

var music_on = false

#lista que contiene a todos los enemigos generados
var enemies = []

var enemy_count = 0
export var max_enemies = 10


export var time_per_wave = 6


var sleep_global_time = 5

#segundos de espera entre oleada
var sleep_wave_timer = 3

#oleada actual
var current_wave = 1

#tiempo que dura la oleada
var time_wave

#tiempo actual de oleada
var time_current_wave = 0

var text_wave_on = false

var wave_on = true


func _ready():
	SAVE.load_data()
	randomize()
	$HudDatos/ExpBar.hide()
	$Loading.hide()
	GLOBALS.connect("enemy_die",self,"_on_enemy_dies")
	GLOBALS.connect("player_die",self,"_on_player_dies")
	GLOBALS.connect("wave_text",self,"_on_wave_text")
	GLOBALS.connect("reset_game",self,"_on_reset_game")
	SETTINGS.connect("change_blindness",self,"_on_change_blindness")
	SETTINGS.connect("change_blindness_intensity",self,"_on_change_blindness_intensity")
	GLOBALS.connect("hide_load",self,"_on_hide_loading")
	GLOBALS.connect("start_game",self,"_on_start_game")



func new_game():
	#$ExpBar.show()
	$Loading.show()
	$Loading.start()




# Timer que spawnea los enemigos en cada oleada
func _on_EnemiesTimer_timeout():
	if time_wave < 1:
		wave_on = false
		$EnemiesTimer.stop()
		$HudDatos/TimerText.hide()
		current_wave +=1
		time_wave = round(time_per_wave + (current_wave * time_per_wave * 0.5))
		$HudDatos/WaitEnemyDieTimer.start()
		return
	if wave_on:
		var enemy
		
		if current_wave < 4:
			enemy = chose_enemy(1)
			
		if current_wave == 4:
			enemy = enemy_beetle_scene.instance()
		
		if current_wave > 4 && current_wave <= 6:
			enemy = chose_enemy(2)
		
		if current_wave == 7:
			enemy = enemy_snail_scene.instance()
		
		if current_wave > 7:
			enemy = chose_enemy(3)
		
		
		enemies.append(enemy)
		
		var enemy_spawn_location = get_node("EnemiesPath/EnemiesPathLocation")
		enemy_spawn_location.offset = randi()
		var new_location = enemy_spawn_location.get_global_transform().origin
		enemy.position = new_location
		enemy.set_values(player,new_location)
		add_child(enemy)
		enemy_count+=1
		time_current_wave+=1
		time_wave -=1
		


# Funcion que retorna un enemigo aleatorio dependiendo el numero que se le dé,
# num es el maximo numero que va a generar el random
func chose_enemy(num):
	var enemy = null
	var random_value = rand_range(0,num)
	# enemigo es hormiga si es menor a 1 el random 
	if random_value <= 1:  
		enemy = enemy_ant_scene.instance()
	# enemigo es escarabajo si es mayor a 1 y menor a 2 el random
	if random_value > 1 && random_value <= 2:
		enemy = enemy_beetle_scene.instance() 
	# enemigo es caracol si es mayor a 2 el random
	if random_value > 2:
		enemy = enemy_snail_scene.instance()
	return enemy



#Muestra el texto en pantalla previo a iniciar la oleada
func see_wave_text():
	print("Enemigos restantes: "+str(enemy_count))
	if enemy_count == 0:
		player.enemies = []
		time_current_wave = 0
		$HudDatos/NumberWaveTimer/NumberWave.show()
		$HudDatos/NumberWaveTimer/NumberWave.text = "Wave #"+str(current_wave)+" start in "+str(sleep_wave_timer)
		$HudDatos/NumberWaveTimer.start()
		$HudDatos/WaitEnemyDieTimer.stop()
		wave_on = true

#Timer que disminuye el tiempo que muestra el texto previo a iniciar la oleada
func _on_NumberWaveTimer_timeout():
	if sleep_wave_timer <= 1:
		$HudDatos/NumberWaveTimer.stop()
		$HudDatos/NumberWaveTimer/NumberWave.hide()
		$EnemiesTimer.start()
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
	#$GameOver.show()
	get_tree().change_scene("res://models/GameOver/GameOver.tscn")
	Input.action_press("ui_cancel")


func _on_wave_text():
	if text_wave_on && enemy_count == 0:
		$HudDatos/NumberWaveTimer/NumberWave.hide()
	if !text_wave_on && enemy_count == 0:
		$HudDatos/NumberWaveTimer/NumberWave.show()
	text_wave_on = !text_wave_on

func _on_reset_game():
	max_enemies = 10
	time_per_wave = 10
	sleep_global_time = 5
	sleep_wave_timer = 5
	current_wave = 1
	time_current_wave = 0
	GLOBALS.emit_signal("can_pause")


func _on_change_blindness(value):
	$BlindnessFilter.material.set_shader_param("mode",value)


func _on_change_blindness_intensity(value):
	$BlindnessFilter.material.set_shader_param("intensity",value)

func _on_hide_loading():
	$Loading.hide()
	$HUD.music_stop()
	time_wave = time_per_wave + (current_wave * time_per_wave * 0.5)
	player.initialize(self, self)
	see_wave_text()	
	text_wave_on = true
	$HUD.show_message("Get Ready")
	player.set_move()
	$SpringMusicTheme.play()
	GLOBALS.emit_signal("can_pause")

func _on_start_game():
	$HUD.hide()
	new_game()
	#deleteEnemies()
	
