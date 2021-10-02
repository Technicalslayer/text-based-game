extends Node
class_name CommandProcessor

enum Command {GO, PICKUP, USE, HELP, LOOK}

class CommandResult:
	var passed_command # enum of type Command
	var valid:bool = false # indicates command can be executed
	var target # target node
	var item # the item that was used
	var text:String # string to display


var current_room: Room
var player


func process_command(input: String) -> CommandResult:
	var result = CommandResult.new()
	var words = input.split(" ", false)
	if words.size() == 0:
		result.text = "Error: no words were parsed"
		return result
		
	var first_word = words[0].to_lower()
	var second_word = ""
	if words.size() > 1:
		second_word = words[1].to_lower()
		
	match first_word:
		"go":
			return go(second_word, result)
		"help":
			return help(result)
		"look":
			return look(second_word, result)
		"pickup", "grab":
			return pickup(second_word, result)
		"use":
			return use(second_word, result)
		_:
			result.text = "Unrecognized command - please try again."
			return result


func go(second_word: String, result: CommandResult) -> CommandResult:
	result.passed_command = Command.GO
	if second_word == "":
		result.text = "Go where?"
		return result
	
	# check that direction is valid
	if second_word in current_room.exits:
		result.text = "You go %s" % second_word
		result.target = current_room.exits[second_word]
		if result.target.locked:
			result.text = "That exit is locked"
		else:
			result.valid = true
			result.target = result.target.connected_exit
	else:
		result.text = "There's not an exit there"
	return result


func help(result: CommandResult) -> CommandResult:
	result.text = "You can use these commands: go [location], help"
	result.passed_command = Command.HELP
	result.valid = true
	return result

func look(second_word: String, result: CommandResult) -> CommandResult:
	result.passed_command = Command.LOOK
	if second_word == "":
		result.text = current_room.description
		return result
	
	if second_word in current_room.exits:
		result.target = current_room.exits[second_word]
		result.text = result.target.description
		if result.target.locked:
			result.text += " It's locked."
		else:
			result.text += " It's unlocked"
		return result
	elif second_word in current_room.items:
		result.target = current_room.items[second_word]
		result.text = result.target.description
		return result
	elif second_word in current_room.characters:
		result.target = current_room.characters[second_word]
		result.text = result.target.description
		return result
	elif second_word == "inv" || second_word == "inventory":
		# parse inventory as text
		result.text = player.inventory_as_text
		return result
	else:
		result.text = "Can't look at something that doesn't exist"
		return result


func pickup(second_word: String, result: CommandResult) -> CommandResult:
	# maybe check if item is locked?
	# "can't pick that up"
	result.passed_command = Command.PICKUP
	if second_word in current_room.items:
		# if valid to pickup
		result.target = current_room.items[second_word]
		result.text = "You put the " + second_word + " in your pocket."
		result.valid = true
	else:
		result.text = "You must be seeing things."
	return result


func use(second_word: String, result: CommandResult) -> CommandResult:
	result.passed_command = Command.USE
	# check that the item is present in the player's inventory
	if second_word in player.inventory:
		result.item = player.inventory[second_word]
		# determine item type and find a target for it
		if result.item is InventoryItem:
			match result.item.item_type:
				Item.Item_Type.KEY:
					result.text = "There isn't a place to use that."
					# check for valid door
					for e in current_room.exits:
						if current_room.exits[e].locked:
							result.target = current_room.exits[e]
							result.text = "Using key"
							result.valid = true
							break
				_:
					printerr("Item_Type response in use function not setup.")
					pass
			pass
		else:
			result.text = "There's nothing to use that on"
	else:
		result.text = "You don't have that in your pockets."
	return result
