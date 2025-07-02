extends Node

# Get a reference to the player node
@onready var audio_player = $AudioStreamPlayer

# Preload your music file for efficiancy
const MENU_MUSIC = preload("res://Audio/tower-defense-8-bit-chiptune-game-music-358521.mp3")
const GAME_MUSIC = preload("res://Audio/Elevator-music(chosic.com).mp3")

func _ready():
	var initial_volume_db = linear_to_db(0.06)
	var music_bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus_index, initial_volume_db)
	
func play_menu_music():
	# Don't restart the music if it's already playing
	if audio_player.stream == MENU_MUSIC and audio_player.playing:
		return
	
	audio_player.volume_db = 0	
	audio_player.stream = MENU_MUSIC
	audio_player.play()
	
func play_game_music():
	# Don't restart the music if it's already playing
	if audio_player.stream == GAME_MUSIC and audio_player.playing:
		return
	
	audio_player.volume_db = 0
	audio_player.stream = GAME_MUSIC
	audio_player.play()
	
func stop_music():
	audio_player.stop()
	
func fade_out_music(duration: float):
	var tween = create_tween()	
	tween.tween_property(audio_player, "volume_db", -80, duration)
	await tween.finished
