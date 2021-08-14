# handles logic that is shared between live and text side
# stores game state and current room reference
extends Node
# this is a test
onready var current_room: Room = find_node("Room")
onready var current_exit: Exit = find_node("Room").find_node("ExitNorth")
onready var player = find_node("Player")
onready var command_processor: CommandProcessor = find_node("CommandProcessor")
onready var text_controller = find_node("TextSide")

func _ready() -> void:
	change_rooms(current_exit)


func change_rooms(exit: Exit):
	# update player position
	player.global_position = exit.entrance_position.global_position
	# switch rooms
	current_room = exit.get_parent()
	
	# update command processor with neccessary info
	command_processor.current_room = current_room
	
	# add text describing room


func _on_Input_text_entered(new_text: String) -> void:
	if new_text.empty(): # do nothing
		return
	var response = command_processor.process_command(new_text)
	
	# change game state based on response
	# get command enum
	if response.valid:
		match response.passed_command:
			CommandProcessor.Command.GO:
				change_rooms(response.target)
			CommandProcessor.Command.PICKUP:
				pass
			CommandProcessor.Command.USE:
				pass
			CommandProcessor.Command.HELP:
				pass
			_:
				pass
	
	# add input and response to display
	text_controller.add_text_as_response(new_text, response.text)
	
