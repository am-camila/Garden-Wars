extends Popup



#Video Settings
onready var mode_btn = $TabsSettings/General/MarginContainer/VideoContainer/ModeOption
onready var bringhtness_btn = $TabsSettings/General/MarginContainer/VideoContainer/GeneralVolumen2/BringhtnessBar

#Audio Settings
onready var genera_bar = $TabsSettings/General/MarginContainer/VideoContainer/GeneralVolumen/GeneralBar
onready var music_bar = $TabsSettings/General/MarginContainer/VideoContainer/MusicVolumen/MusicBar
onready var sfx_bar = $TabsSettings/General/MarginContainer/VideoContainer/SfxVolumen/SfxBar

#Gameplay Settings
onready var blinghtness_btn = $TabsSettings/General/MarginContainer/VideoContainer/BlindnessOption

func _ready():
	pass


func _on_ModeOption_item_selected(index):
	SETTINGS.change_display_mode(index)



func _on_BringhtnessBar_value_changed(value):
	print("cambie a "+str(value))



func _on_GeneralBar_value_changed(value):
	SETTINGS.change_master_volumen(value)


func _on_MusicBar_value_changed(value):
	SETTINGS.change_master_volumen(value)


func _on_SfxBar_value_changed(value):
	SETTINGS.change_master_volumen(value)


func _on_BlindnessOption_pressed():
	pass # Replace with function body.


func _on_Close_pressed():
	hide()
