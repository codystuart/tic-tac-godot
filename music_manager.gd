extends Node

# Get a reference to the player node
@onready var audio_player = $AudioStreamPlayer

# Preload your music file for efficiancy
const MENU_MUSIC = preload("res://Audio/tower-defense-8-bit-chiptune-game-music-358521.mp3")
const GAME_MUSIC = preload("res://Audio/Elevator-music(chosic.com).mp3")
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
