extends Node

func play(sound_resource):
	var player = AudioStreamPlayer.new()
	
	player.stream = sound_resource
	
	player.finished.connect(player.queue_free)
	
	add_child(player)
	
	player.play()
