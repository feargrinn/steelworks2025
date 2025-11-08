extends Node

@onready var sfx: Node = $sfx
var audio_players: Array[AudioStreamPlayer]

var music_value = 0.5
var sfx_value = 0.5


func _ready() -> void:
	for n in sfx.get_children():
		if n is AudioStreamPlayer:
			audio_players.append(n)


func play_music():
	$Music.play()


func play_sfx(sound_name: String):
	var idx: int = audio_players.find_custom(func(node: Node): return node.name == sound_name)
	assert(idx != -1, "No sound with name: %s" % sound_name)
	audio_players[idx].play()


func set_sfx_playing(sound_name: String, playing: bool):
	var idx: int = audio_players.find_custom(func(node: Node): return node.name == sound_name)
	assert(idx != -1, "No sound with name: %s" % sound_name)
	if audio_players[idx].playing != playing:
		audio_players[idx].playing = playing
