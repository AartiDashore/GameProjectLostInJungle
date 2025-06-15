class_name SoundFacade
extends Node

@onready var ambient_player = get_node("/root/Main/ForestAmbientAudio")
@onready var footstep_player = get_node("/root/Main/Player/WalkSound")
#@onready var combat_player = $CombatAudio
#@onready var dialogue_player = $DialogueAudio

func play_ambient(sound_name: String):
	ambient_player.stream = load("res://assets/sound/" + sound_name + ".mp3")
	ambient_player.play()

func play_footstep(sound_name: String):
	footstep_player.stream = load("res://assets/sound/" + sound_name + ".wav")
	footstep_player.play()

#func play_combat(sound_name: String):
	#combat_player.stream = load("res://sounds/combat/" + sound_name + ".ogg")
	#combat_player.play()
#
#func play_dialogue(sound_name: String):
	#dialogue_player.stream = load("res://sounds/dialogue/" + sound_name + ".ogg")
	#dialogue_player.play()
