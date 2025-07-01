extends Control

# Opponent button references
@onready var opponent_choice_panel = $PanelContainer
@onready var human_button = $PanelContainer/VBoxContainer/HumanButton
@onready var ai_button = $PanelContainer/VBoxContainer/AIButton
@onready var back_button = $PanelContainer/VBoxContainer/BackButton

# Difficulty button references
@onready var ai_difficulty_options = $VBoxContainer/DifficultyButton

const SOUND_UI_CLICK = preload("res://Audio/click_002.ogg")

func _ready():
	# Connect the buttons inside of the PanelContinaer
	human_button.pressed.connect(_on_human_button_pressed)
	ai_button.pressed.connect(_on_ai_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	
	ai_difficulty_options.item_selected.connect(_on_difficulty_selected)
	if GameManager.game_mode == "easy":
		ai_difficulty_options.select(0)
	elif GameManager.game_mode == "hard":
		ai_difficulty_options.select(1)
	
# --- Popup panel button functions ---
func _on_human_button_pressed():
	GameManager.game_mode = "pvp"
	SfxManager.play(SOUND_UI_CLICK)
	await MusicManager.fade_out_music(1.0)
	get_tree().change_scene_to_file("res://tic_tac_toe.tscn")
	
func _on_ai_button_pressed():
	#GameManager.game_mode = "easy" # TODO: Fix this so that the option dropdown selection actually sets the AI difficulty.
	SfxManager.play(SOUND_UI_CLICK)
	await MusicManager.fade_out_music(1.0)
	$PanelContainer.hide()
	$VBoxContainer.show()
	#get_tree().change_scene_to_file("res://tic_tac_toe.tscn")

func _on_back_button_pressed():
	SfxManager.play(SOUND_UI_CLICK)
	get_tree().change_scene_to_file("res://main_menu.tscn")
	
func _on_difficulty_selected(index):
	if index == 0:
		GameManager.game_mode = "easy"
		get_tree().change_scene_to_file("res://tic_tac_toe.tscn")
	elif index == 1:
		GameManager.game_mode = "hard"
		get_tree().change_scene_to_file("res://tic_tac_toe.tscn")
