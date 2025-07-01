extends Node

#Game Mode Signal
signal game_mode_changed

# Manages global game state variables
var game_mode = "pvp": # Can be pvp, easy, or hard
	set(new_value):
		game_mode = new_value
		game_mode_changed.emit()
