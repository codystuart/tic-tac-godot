extends Node

@onready var audio_player = $AudioStreamPlayer

"""func play(sound_resource):
	var player = AudioStreamPlayer.new()
	
	player.stream = sound_resource
	
	player.finished.connect(player.queue_free)
	
	add_child(player)
	
	player.play()
"""
func _ready():
	var initial_volume = linear_to_db(0.5)
	var sfx_bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_bus_index, initial_volume)
	
func play(sound_resource):
	if not sound_resource:
		print("SFXManager: Tried to play a null sound.")
		return
		
	audio_player.stream = sound_resource
	audio_player.play()
