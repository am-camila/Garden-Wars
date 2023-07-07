extends Node2D

signal enemy_die
signal hit
signal wave_end
signal player_die
signal spawn_powerup
signal restoreAttributes
signal wave_text
signal reset_game
signal start_game
signal hide_load
signal can_pause

func _ready():
	randomize()
