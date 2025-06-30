extends Control

@onready var music_slider = $CenterContainer/VBoxContainer/MusicVolumeSlider
@onready var sfx_slider = $CenterContainer/VBoxContainer/SFXVolumeSlider
@onready var back_button = $CenterContainer/VBoxContainer/BackButton

const SOUND_UI_CLICK = preload("res://Audio/click_002.ogg")

var music_bus_index = AudioServer.get_bus_index("Music")
var sfx_bus_index = AudioServer.get_bus_index("SFX")

func _ready():
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	back_button.pressed.connect(_on_back_button_pressed)
	
	music_slider.value = AudioServer.get_bus_volume_db(music_bus_index)
	sfx_slider.value = AudioServer.get_bus_volume_db(sfx_bus_index)
	
func _on_music_volume_changed(value):
	AudioServer.set_bus_volume_db(music_bus_index, value)
	
func _on_sfx_volume_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus_index, value)
	
func _on_back_button_pressed():
	SfxManager.play(SOUND_UI_CLICK)
	
	get_tree().change_scene_to_file("res://main_menu.tscn")
