extends Area2D
class_name Exit

enum {KEY, NPC, ENEMY, SWITCH, PUZZLE}

export (NodePath) var connected_exit_path
onready var connected_exit = get_node(connected_exit_path)
export (String) var direction = ""
export (String) var description = ""
export (bool) var locked = false
# this represents where to place the player when entering
onready var entrance_position = $Position2D

signal player_entered


func _ready() -> void:
	var controller = get_node("/root/Main")
	connect("player_entered", controller, "change_rooms")


func _on_body_entered(body: Node) -> void:
	print("Exit: " + name)
	# move player to connected exit's position node
	if body.is_in_group("player"):
		if locked:
			# indicate that door is locked
			pass
		else:
			emit_signal("player_entered", connected_exit)
