extends CanvasLayer

var count = 0


var english_text = ["Movement","Auto Fire","Special Attack","Use the W, A, S, and D keys to move the character","You dont need to worry about shooting as it is done automatically","Use the F key to perform a powerful attack, but be careful with your life points","Loading",]
var spanish_text = ["Movimiento","Disparo","Ataque Especial","Use las teclas W, A, S, y D para mover al jugador","No necesitas preocuparte por disparar, ya que es automatico","Usa la tecla F para disparar un poderoso ataque, pero cuidado con tu vida","Cargando"]
var languaje = []


func _ready():
	languaje = spanish_text
	$Movement/Label.text = languaje[0]
	$AutoFire/Label2.text = languaje[1]
	$SpecialAttack/Label3.text = languaje[2]
	$Movement/MoveDescription.text = languaje[3]
	$AutoFire/AutoFireDescription.text = languaje[4]
	$SpecialAttack/SpecialAttackDescription.text = languaje[5]
	$LoadingLabel.text = languaje[6]
	

func start():
	$Timer.start()

func _on_Timer_timeout():
	count += 1
	if !$Movement.is_playing():
		$Movement.play()
		
	if !$AutoFire.is_playing():
		$AutoFire.play()
		
	if !$SpecialAttack.is_playing():
		$SpecialAttack.play()
	if count % 2 == 1:
		$LoadingLabel.text = languaje[6]
	$LoadingLabel.text += "."
	if count == 6:
		$Movement.stop()
		$AutoFire.stop()
		$SpecialAttack.stop()
		$Timer.stop()
		GLOBALS.emit_signal("hide_load")
