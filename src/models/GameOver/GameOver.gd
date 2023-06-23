extends CanvasLayer

var Music = load("res://assets/songs/Game_Over.ogg")
var music = AudioStreamPlayer.new()

func _ready():
	music.stream = Music
	
	
	
func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://models/Main/Main.tscn")
	$GameOverMusic.stop()
