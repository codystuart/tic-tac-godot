extends Control

# We need to get references to our buttons.
@onready var start_button = $CenterContainer/VBoxContainer/StartButton
@onready var quit_button = $CenterContainer/VBoxContainer/QuitButton
@onready var settings_button = $CenterContainer/VBoxContainer/SettingsButton

# Opponent Pop-up Panel button references
@onready var opponent_choice_panel = $PanelContainer
@onready var human_button = $PanelContainer/VBoxContainer/HumanButton
@onready var ai_button = $PanelContainer/VBoxContainer/AIButton
@onready var back_button = $PanelContainer/VBoxContainer/BackButton

# Preload sounds
const SOUND_UI_CLICK = preload("res://Audio/click_002.ogg")

func _ready():
	# Connect the signals when the scene loads.
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	
	# Connect the buttons inside of the PanelContinaer
	human_button.pressed.connect(_on_human_button_pressed)
	ai_button.pressed.connect(_on_ai_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	
	#Start playing the menu music as soon as the menu loads
	MusicManager.play_menu_music()

func _on_start_button_pressed():
	SfxManager.play(SOUND_UI_CLICK)
	opponent_choice_panel.show()
	
func _on_quit_button_pressed():
	SfxManager.play(SOUND_UI_CLICK)
	get_tree().quit()
	
func _on_settings_button_pressed():
	SfxManager.play(SOUND_UI_CLICK)
	get_tree().change_scene_to_file("res://settings_menu.tscn")

# --- Popup panel button functions ---

func _on_back_button_pressed():
	SfxManager.play(SOUND_UI_CLICK)
	opponent_choice_panel.hide()
	
func _on_human_button_pressed():
	GameManager.is_ai_game = false
	SfxManager.play(SOUND_UI_CLICK)
	await MusicManager.fade_out_music(1.0)
	get_tree().change_scene_to_file("res://tic_tac_toe.tscn")
	
func _on_ai_button_pressed():
	GameManager.is_ai_game = true
	SfxManager.play(SOUND_UI_CLICK)
	await MusicManager.fade_out_music(1.0)
	get_tree().change_scene_to_file("res://tic_tac_toe.tscn")
	
