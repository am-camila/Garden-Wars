extends Node2D

signal enemy_die
signal hit
signal wave_end
signal player_die
signal spawn_powerup
signal restoreAttributes

func _ready():
	randomize()
