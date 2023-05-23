extends CanvasLayer

signal start_game

func _ready():
	$HubTheme.play()

func show_message(text):
	$Title.text = text
	$Title.show()
	#$MessageTimer.start()


func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$Title.text = "Garden Wars"
	$Title.show()
	yield(get_tree().create_timer(1),"timeout")
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_StartButton_pressed():
	$HubTheme.stop()
	$VBoxContainer/StartButton.hide()
	$VBoxContainer/ExitButton.hide()
	$VBoxContainer/SettingsButton.hide()
	$MarginContainer/Footer.hide()
	$Background.hide()
	emit_signal("start_game")
	$Title.hide()

func _on_MessageTimer_timeout():
	$Title.hide()


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_SettingsButton_pressed():
	$Settings.popup_centered()
