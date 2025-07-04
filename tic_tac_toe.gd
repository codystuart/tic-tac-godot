extends Control

# --- NODES ---
@onready var label = $Label
@onready var grid_container = $GridContainer
@onready var restart_button = $RestartButton
@onready var menu_button = $MenuButton
@onready var input_shield = $InputShield
@onready var start_ai_timer = $StartAITimer

#Preload all the sound affects needed
const SOUND_PLACE_PIECE = preload("res://Audio/select_002.ogg")
const SOUND_WIN = preload("res://Audio/jingles_NES03.ogg")
const SOUND_UI_CLICK = preload("res://Audio/click_002.ogg")

# --- GAME STATE VARIABLES ---
# An array to represent the 3x3 board. 0 = empty, 1 = player X, -1 = player O.
var board = [0,0,0,0,0,0,0,0,0]
# Variable to track whose turn it is. 1 for X, -1 for O. We'll start with X. 
var current_player = 1
# A flag to stop the game when someone wins or it's a draw.
var game_over = false

# Player Marker Variables
var player_marker = 1
var ai_marker = -1

# --- GAME INIT ---
# This function is called automatically when the node enters the scene tree (i.e., when the game starts).
func _ready():
	input_shield.size = grid_container.size
	input_shield.position = grid_container.position
	# We need to connect the 'pressed' signal of each button to our script.
	# This loop goes through all 9 buttons in the GridContainer.
	for i in range(grid_container.get_child_count()):
			var button = grid_container.get_child(i)
			# The 'connect' method links a signal to a function.
			# We're saying: when this button is pressed, call the _on_button_pressed function".
			# The [i] part sends the button's index (0-8) to our function so we know which one was clicked.
			button.pressed.connect(_on_button_pressed.bind(i))
	# Set the initial turn message.
	update_status_label()
	restart_button.pressed.connect(restart_game)
	menu_button.pressed.connect(_on_menu_button_pressed)

	start_ai_timer.timeout.connect(_on_start_ai_timer_timeout)
	_start_new_round()
	MusicManager.play_game_music()

func _start_new_round():
	game_over = false
	board = [0,0,0,0,0,0,0,0,0]
	current_player = 1
	
	# Reset player markers for pvp
	player_marker = 1
	ai_marker = -1
	
	for i in range(grid_container.get_child_count()):
		var button = grid_container.get_child(i)
		button.text = ""
	restart_button.hide()
	menu_button.hide()
	
	if GameManager.game_mode != "pvp":
		randomize()
		if randi() % 2 == 1: 
			print ("AI starts")
			player_marker = -1
			ai_marker = 1
			input_shield.show()
			start_ai_timer.start()
		else:
			print("Player starts")
			input_shield.hide()
			
	update_status_label()
			
func restart_game():
	SfxManager.play(SOUND_UI_CLICK)
	_start_new_round()
	
# --- CORE GAME FUNCTIONS ---
# This function is called whenever any of our 9 grid buttons are pressed.
# The 'index' paramerter tells us which button was clicked (0 - 8).
func _on_button_pressed(index):
		# First, check if the spot is already taken or if the game is over. If so, do nothing.
		if board[index] !=0 or game_over:
			return # Exit the function early
		SfxManager.play(SOUND_PLACE_PIECE)
		# Update the board state with the current player's number
		board[index] = current_player
		# Get the actual button node that was pressed and update its text.
		var button = grid_container.get_child(index)
		button.text = "X" if current_player == 1 else "O"
		# Check if this move resulted in a win.
		if check_for_win():
			game_over = true
			var winner = "X" if current_player == 1 else "O"
			label.text = "Player " + winner + " Wins!"
			SfxManager.play(SOUND_WIN)
			restart_button.show()
			menu_button.show()
		# if no one won, check if it's a draw.
		elif check_for_draw():
			game_over = true
			label.text = "It's a Draw!"
			restart_button.show()
			menu_button.show()
		# if the game is still going, switch players.
		else:
			# Switch the player. if current_player is 1, it becomes -1. if it's -1, it becomes 1.
			current_player *=-1
			update_status_label()
			
		if GameManager.game_mode != "pvp" and current_player == ai_marker and not game_over:
			input_shield.show()
			await get_tree().create_timer(2.5).timeout
			_ai_make_move()
			input_shield.hide()

func _on_menu_button_pressed():
		SfxManager.play(SOUND_UI_CLICK)
		await MusicManager.fade_out_music(1.0)
		get_tree().change_scene_to_file("res://main_menu.tscn")

# A helper function to update the message label with the current turn.
func update_status_label():
		# pvp
		var player_char = "X" if current_player == 1 else "O"
		label.text = "Player " + player_char + "'s Turn"
		# AI games
		if GameManager.game_mode != "pvp":
			if current_player == player_marker:
				label.text = "Player " + player_char + "'s Turn"
			else:
				label.text = "AI " + player_char + "'s Turn"
		else:
			label.text = "Player " + player_char + "'s Turn"
			

# A function to check all winning conditions. 
func check_for_win():
		const WIN_CONDITIONS = [
			[0,1,2],[3,4,5],[6,7,8], # Rows
			[0,3,6],[1,4,7],[2,5,8], # Columns
			[0,4,8],[2,4,6] # Diagonals			
		]

		for condition in WIN_CONDITIONS:
				# Get the values from our board array for the three positions in the current win condition.
				var a = board[condition[0]]
				var b = board[condition[1]]
				var c = board[condition[2]]
				
				# Check if they are all the same and not empty (not 0).
				if a == b and b ==c and a != 0:
					return true # A win was found
					
		return false # No win was found.
		
# A function to check if the board is full.
func check_for_draw():
		# If we find any 0 (an empty spot) in our board array, it's not a draw yet.
		for spot in board:
			if spot == 0:
				return false # Found an empty spot, so not a draw
				
		# If the loop finishes without finding any empty spots, the board is full. 
		return true # it's a draw

# --- COMPUTER OPPONENT ---
func _on_start_ai_timer_timeout():
	_ai_make_move() 
	input_shield.hide()
	
func _ai_make_move():
	if GameManager.game_mode == "easy":
		_ai_easy_move()
	else:
		_ai_hard_move()
		
func _ai_easy_move():
	var available_spots = []
	for i in range(board.size()):
		if board[i] == 0:
			available_spots.append(i)
	
	if not available_spots.is_empty():
		available_spots.shuffle()
		var random_spot_index = available_spots.front()
		_on_button_pressed(random_spot_index)

func _ai_hard_move():
	# --- Priority 1: Check for a winning move (Offense) ---
	for i in range(board.size()):
		# Check only empty spots
		if board[i] == 0:
			# Temporarily make the move for the AI
			board[i] = ai_marker # AI is player -1
			# Check if this move is a winner
			if check_for_win():
				# If it is, undo the temporary move (good practice)
				board[i] = 0
				# Make the winning move for real and stop searching.
				_on_button_pressed(i)
				return # Exit the function since we found our best move
			# IMPORTANT: Undo the temporary move to continue searching
			board[i] = 0
			
	# --- Priority 2: Check for a blocking move (Defense) ---
	for i in range(board.size()):
		# Check only empty spots
		if board[i] == 0:
			# Temporarily make the move for the PLAYER
			board[i] = player_marker
			# Check if this move would make the player win
			if check_for_win():
				# If it would, we must block it. Undo the temp move.
				board[i] = 0
				# Make the blocking move FOR THE AI and stop searching.
				_on_button_pressed(i)
				return # Exit the function
			# IMPORTANT: Undo the temporary move
			board[i] = 0
	# --- Priority 3: Make a random move
	_ai_easy_move()
