extends ProgressBar


export var current_lvl = 1
var enemies_killed = 0

func _ready():
	GLOBALS.connect("enemy_die",self,"_on_enemy_die")
	self.min_value = 0
	self.max_value = 100
	$ExpLabel.hide()

func _physics_process(delta):
	check_exp()


func _on_enemy_die():
	$ExpLabel.show()
	$ExpTimer.start()
	$ExpLabel.text = "+10 exp"
	self.value += 10
	enemies_killed += 1



func check_exp():
	if self.value >= self.max_value:
		current_lvl += 1
		self.value = 0
		self.max_value += 50


func _on_ExpTimer_timeout():
	$ExpLabel.hide()
