extends Popup



#Video Settings
onready var mode_btn = $TabsSettings/General/MarginContainer/VideoContainer/ModeOption

#Audio Settings
onready var genera_bar = $TabsSettings/General/MarginContainer/VideoContainer/GeneralVolumen/GeneralBar
onready var music_bar = $TabsSettings/General/MarginContainer/VideoContainer/MusicVolumen/MusicBar
onready var sfx_bar = $TabsSettings/General/MarginContainer/VideoContainer/SfxVolumen/SfxBar

#Gameplay Settings
onready var blinghtness_btn = $TabsSettings/General/MarginContainer/VideoContainer/BlindnessOption
onready var blinghtness_intensity = $TabsSettings/General/MarginContainer/VideoContainer/Intensity/IntensityBar

func _ready():
	initialize_data()


func initialize_data():
	mode_btn.select(1 if SAVE.game_data.full_screen_mode else 0)
	genera_bar.value = SAVE.game_data.general_volumen
	music_bar.value = SAVE.game_data.music_volumen
	sfx_bar.value = SAVE.game_data.sfx_volumen
	blinghtness_btn.selected = SAVE.game_data.blindness
	blinghtness_intensity.value = SAVE.game_data.blindness_intensity

func _on_ModeOption_item_selected(index):
	SETTINGS.change_display_mode(index)


func _on_GeneralBar_value_changed(value):
	SETTINGS.change_master_volumen(value)


func _on_MusicBar_value_changed(value):
	SETTINGS.change_music_volumen(value)


func _on_SfxBar_value_changed(value):
	SETTINGS.change_sfx_volumen(value)


func _on_BlindnessOption_item_selected(index):
	SETTINGS.change_blindness(index)


func _on_IntensityBar_value_changed(value):
	SETTINGS.change_blindness_intensity(value)

func _on_Close_pressed():
	SAVE.load_data()
	hide()


func _on_Save_pressed():
	SAVE.save_data()
	hide()



