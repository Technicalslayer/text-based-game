extends Node2D
class_name Room #allow passing as a class


var exits =  {} # key: exit direction, value: connected_exit
var items = {} # key: name, value: node
var characters = {} # key: name, value: node

export (String) var description = ""
var exit_list: String = "Exits: "
var item_list: String = "Items: "
var character_list: String = "Characters: "


func _ready() -> void:
	# populate exits dictionary
	for i in get_children():
		if i.is_in_group("exits"):
			exits[i.direction.to_lower()] = i.connected_exit
			exit_list += i.name + "  "
		if i.is_in_group("items"):
			items[i.name.to_lower()] = i
			item_list += i.name + " "
		if i.is_in_group("characters"):
			characters[i.name.to_lower()] = i
			character_list += i.name + " "
	
#	print(exits)


func connect_exits():
	# add two way connnections, might not implement
	pass
