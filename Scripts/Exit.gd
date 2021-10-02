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
signal action_spoofed(spoofed_text)


func _ready() -> void:
	var controller = get_node("/root/Main")
#	connect("player_entered", controller, "change_rooms")
	connect("action_spoofed", controller, "_on_Input_spoofed")


func _on_body_entered(body: Node) -> void:
	print("Exit: " + name)
	# move player to connected exit's position node
	if body.is_in_group("player"):
		var input_string = "go " + name
		emit_signal("action_spoofed", input_string)
