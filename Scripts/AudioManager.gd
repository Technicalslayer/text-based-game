extends Node

enum Sound_Clips {DOOR, UNLOCK, PICKUP}

onready var _door_sound_player:AudioStreamPlayer = $DoorOpenPlayer
onready var _door_unlock_player:AudioStreamPlayer = $DoorUnlockPlayer
onready var _pickup_item_player:AudioStreamPlayer = $PickupItemPlayer
onready var _music_player:AudioStreamPlayer = $MusicPlayer

func play_audio(sound):
	match sound:
		Sound_Clips.DOOR:
			_door_sound_player.play()
			pass
		Sound_Clips.UNLOCK:
			_door_unlock_player.play()
			pass
		Sound_Clips.PICKUP:
			_pickup_item_player.play()
			pass
