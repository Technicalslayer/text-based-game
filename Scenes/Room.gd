extends Node2D
class_name Room #allow passing as a class


var exits =  {}
export (String) var description = ""

func _ready() -> void:
	# populate exits dictionary
	for i in get_children():
		if i.is_in_group("exits"):
			exits[i.direction.to_lower()] = i.connected_exit
	
	print(exits)


func connect_exits():
	# add two way connnections, might not implement
	pass
