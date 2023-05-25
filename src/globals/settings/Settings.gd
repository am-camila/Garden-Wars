extends Node


func _ready():
	pass


#Display settings

func change_display_mode(value):
	OS.window_fullscreen = value
	SAVE.game_data.full_screen_mode = true if value else false


#Audio settings

func change_master_volumen(vol):
	AudioServer.set_bus_volume_db(0,vol)
	SAVE.game_data.general_volumen = vol


func change_music_volumen(vol):
	AudioServer.set_bus_volume_db(1,vol)
	SAVE.game_data.music_volumen = vol


func change_sfx_volumen(vol):
	AudioServer.set_bus_volume_db(2,vol)
	SAVE.game_data.sfx_volumen = vol


func load_data():
	OS.window_fullscreen = (true if SAVE.game_data.full_screen_mode else false)
	AudioServer.set_bus_volume_db(0,SAVE.game_data.general_volumen)
	AudioServer.set_bus_volume_db(1,SAVE.game_data.music_volumen)
	AudioServer.set_bus_volume_db(2,SAVE.game_data.sfx_volumen)
