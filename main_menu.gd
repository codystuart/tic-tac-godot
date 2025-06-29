extends Control

# We need to get references to our buttons.
@onready var start_button = $CenterContainer/VBoxContainer/StartButton
@onready var quit_button = $CenterContainer/VBoxContainer/QuitButton
@onready var sfx_player = $SFXPlayer

# Preload sounds
const SOUND_UI_CLICK = preload("res://Audio/click_002.ogg")

func _ready():
	# Connect the signals when the scene loads.
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

	#Start playing the menu music as soon as the menu loads
	MusicManager.play_menu_music()

func _on_start_button_pressed():
	play_sfx(SOUND_UI_CLICK)
	
	await MusicManager.fade_out_music(1.0)
	
	# Make sure the path is correct for game scene file.
	get_tree().change_scene_to_file("res://tic_tac_toe.tscn")
	
func _on_quit_button_pressed():
	play_sfx(SOUND_UI_CLICK)
	# This function closes the game.
	get_tree().quit()
	
func play_sfx(sound):
	sfx_player.stream = sound
	sfx_player.play()
