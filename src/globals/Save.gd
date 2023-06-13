extends Node2D

const save_file = "user://config.save"


var game_data = {}


func _ready():
	load_data()


func load_data():
	var file = File.new()
	if not file.file_exists("user://config.save") :
		game_data = {
			"full_screen_mode" : false,
			"general_volumen" : -15,
			"music_volumen" : -15,
			"sfx_volumen" : -15,
			"blindness" : 0,
			"blindness_intensity" : 1
		}
		save_data()
	
	#Abre el archivo
	file.open(save_file,File.READ)
	#Toma los datos del archivo como los settings principales
	game_data = file.get_var()
	#Cierra el archivo
	file.close()
	
	SETTINGS.load_data()


func save_data():
	var file = File.new()
	file.open(save_file,File.WRITE)
	file.store_var(game_data)
	file.close()
