extends Control

# Game Mode Display Reference
@onready var current_game_mode_label = $GameModeDisplayLabel

# Opponent button references
@onready var opponent_choice_panel = $PanelContainer
@onready var human_button = $PanelContainer/VBoxContainer/HumanButton
@onready var ai_button = $PanelContainer/VBoxContainer/AIButton
@onready var back_button = $PanelContainer/VBoxContainer/BackButton

# Difficulty button references
@onready var ai_difficulty_options = $PanelContainer/VBoxContainer2/DifficultyButton
@onready var start_button = $PanelContainer/VBoxContainer2/StartButton
@onready var ai_back_button = $PanelContainer/VBoxContainer2/AIBackButton

const SOUND_UI_CLICK = preload("res://Audio/click_002.ogg")

func _ready():
	# Connect to game mode signal
	GameManager.game_mode_changed.connect(update_display)
	
	# Connect the buttons inside of the PanelContinaer
	human_button.pressed.connect(_on_human_button_pressed)
	ai_button.pressed.connect(_on_ai_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	
	start_button.pressed.connect(_on_start_button_pressed)
	ai_back_button.pressed.connect(_on_ai_back_button_pressed)
	ai_difficulty_options.item_selected.connect(_on_difficulty_selected)
	if GameManager.game_mode == "easy":
		ai_difficulty_options.select(0)
	elif GameManager.game_mode == "hard":
		ai_difficulty_options.select(1)
		
func update_display():
	# Read the current game mode from GameManager and then,
	# Set the label's text to display the current game mode
	var current_mode = GameManager.game_mode
	current_game_mode_label.text = "Current Game Mode: " + current_mode.capitalize()
	
	
# --- Popup panel button functions ---
func _on_human_button_pressed():
	GameManager.game_mode = "pvp"
	SfxManager.play(SOUND_UI_CLICK)
	await MusicManager.fade_out_music(1.0)
	get_tree().change_scene_to_file("res://tic_tac_toe.tscn")
	
func _on_ai_button_pressed():
	# Default to easy as the game mode when AI is selected
	GameManager.game_mode = "easy"
	SfxManager.play(SOUND_UI_CLICK)
	await MusicManager.fade_out_music(1.0)
	$PanelContainer/VBoxContainer.hide()
	$PanelContainer/VBoxContainer2.show()

func _on_back_button_pressed():
	SfxManager.play(SOUND_UI_CLICK)
	get_tree().change_scene_to_file("res://main_menu.tscn")
	
func _on_ai_back_button_pressed():
	SfxManager.play(SOUND_UI_CLICK)
	$PanelContainer/VBoxContainer2.hide()
	$PanelContainer/VBoxContainer.show()
	
func _on_difficulty_selected(index):
	if index == 0:
		GameManager.game_mode = "easy"
	elif index == 1:
		GameManager.game_mode = "hard"

func _on_start_button_pressed():
	SfxManager.play(SOUND_UI_CLICK)
	if ai_difficulty_options.get_selected_id() == 0:
		GameManager.game_mode = "easy"
	else: # easy has an ID of 0 and hard an ID of 1, so if the ID isn't 0 (easy), then it must be 1 (hard)
		GameManager.game_mode = "hard"
	get_tree().change_scene_to_file("res://tic_tac_toe.tscn")
