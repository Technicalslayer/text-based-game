# handles logic that is shared between live and text side
# stores game state and current room reference
extends Node


onready var current_room = find_node("Room")
onready var current_exit: Exit = find_node("Room").find_node("North")
onready var player = find_node("Player")
onready var command_processor: CommandProcessor = find_node("CommandProcessor")
onready var text_controller = find_node("TextSide")

var inventory_item_scene = preload("res://Scenes/InventoryItem.tscn")


func _ready() -> void:
	change_rooms(current_exit)
	# pass reference
	if command_processor:
		command_processor.player = player


func change_rooms(exit: Exit):
	# update player position
	player.global_position = exit.entrance_position.global_position
	# switch rooms
	current_room = exit.get_parent()
	
	# update command processor with neccessary info
	command_processor.current_room = current_room
	
	# add text describing room
	text_controller.add_response(current_room.description)
	
	# list off exits and objects of interest
	text_controller.add_response(current_room.exit_list)
	text_controller.add_response(current_room.item_list)
#	text_controller.add_response(current_room.character_list)


func _on_Input_text_entered(new_text: String) -> void:
	if new_text.empty(): # do nothing
		return
	var response = command_processor.process_command(new_text)
	
	# add input and response to display
	text_controller.add_input_and_response(new_text, response.text)
	
	# change game state based on response
	# get command enum
	if response.valid:
		match response.passed_command:
			CommandProcessor.Command.GO:
				change_rooms(response.target)
			CommandProcessor.Command.PICKUP:
				# move target to player's inventory
				pickup_item(response)
				pass
			CommandProcessor.Command.USE:
				use_item(response)
				pass
			CommandProcessor.Command.HELP:
				pass
			CommandProcessor.Command.LOOK:
#				if response.target == "player":
#					response.text = player.inventory_as_text # FIXME: this is bad? Doing function of command processor
				pass
			_:
				pass


func pickup_item(response):
	if response.valid:
		# move item to player's inventory
		var inv_item = inventory_item_scene.instance()
		inv_item.name = response.target.name
		inv_item.description = response.target.description
		inv_item.item_type = response.target.item_type
		
		player.add_item(inv_item)
		# remove item from room
		response.target.queue_free()
	pass


func use_item(response):
	if response.valid:
		match response.item.item_type:
			Item.Item_Type.KEY:
				# unlock door
				response.target.locked = false
#				response.target.unlock_door()
				# remove key
				player.remove_item(response.item)
