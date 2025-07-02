extends Node

@onready var audio_player = $AudioStreamPlayer

"""func play(sound_resource):
	var player = AudioStreamPlayer.new()
	
	player.stream = sound_resource
	
	player.finished.connect(player.queue_free)
	
	add_child(player)
	
	player.play()
"""

func play(sound_resource):
	if not sound_resource:
		print("SFXManager: Tried to play a null sound.")
		return
		
	audio_player.stream = sound_resource
	audio_player.play()
