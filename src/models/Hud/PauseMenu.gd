extends CanvasLayer


onready var settings = $Settings


func _ready():
	pass


func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		GLOBALS.emit_signal("wave_text")
		$Settings.initialize_data()
		visible = not visible
		get_tree().paused = not get_tree().paused

func _on_ResumetButton_pressed():
	get_tree().paused = false
	hide()


func _on_SettingsButton_pressed():
	settings.popup()



func _on_MainMenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://models/Main/Main.tscn")
