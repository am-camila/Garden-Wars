extends Button

var menu: Node

func _ready():
	menu = get_node("Menu")  # Assuming the menu is a child node of the button

func _on_Button_pressed():
	menu.show()  # Show the menu when the button is pressed
	menu.set_process_input(true)  # Enable input processing for the menu
