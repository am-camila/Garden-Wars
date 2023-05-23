extends Node


#Signals

signal brightness_changed(value)
signal display_settings(value)


func _ready():
	pass


#Display settings

func change_display_mode(value):
	OS.window_fullscreen = value


func change_brightness(value):
	emit_signal("brightness_changed",value)

#Audio settings

func change_master_volumen(vol):
	AudioServer.set_bus_volume_db(0,vol)


func change_music_volumen(vol):
	AudioServer.set_bus_volume_db(1,vol)


func change_sfx_volumen(vol):
	AudioServer.set_bus_volume_db(2,vol)
