extends Control

# We need to get references to our buttons.
@onready var start_button = $CenterContainer/VBoxContainer/StartButton
@onready var quit_button = $CenterContainer/VBoxContainer/QuitButton
@onready var settings_button = $CenterContainer/VBoxContainer/SettingsButton

# Preload sounds
const SOUND_UI_CLICK = preload("res://Audio/click_002.ogg")

func _ready():
	# Connect the signals when the scene loads.
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	
	#Start playing the menu music as soon as the menu loads
	MusicManager.play_menu_music()

func _on_start_button_pressed():
	SfxManager.play(SOUND_UI_CLICK)
	get_tree().change_scene_to_file("res://game_start_settings.tscn")
	
func _on_quit_button_pressed():
	SfxManager.play(SOUND_UI_CLICK)
	get_tree().quit()
	
func _on_settings_button_pressed():
	SfxManager.play(SOUND_UI_CLICK)
	get_tree().change_scene_to_file("res://settings_menu.tscn")
