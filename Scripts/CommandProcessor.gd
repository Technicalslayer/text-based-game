extends Node
class_name CommandProcessor

enum Command {GO, PICKUP, USE, HELP}

class CommandResult:
	var passed_command # enum of type Command
	var valid:bool = false # indicates command can be executed
	var target # target node
	var text:String # string to display


var current_room: Room


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
	else:
		result.text = "There's not an exit there"
	return result


func help(result: CommandResult) -> CommandResult:
	result.text = "You can use these commands: go [location], help"
	result.passed_command = Command.HELP
	result.valid = true
	return result
