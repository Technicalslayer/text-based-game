extends KinematicBody2D

export (int) var move_speed = 200

var inventory = {} # key: item name, value: node
var inventory_as_text: String = "In your pockets, you have: "
var last_movement: Vector2

signal item_collided
signal action_spoofed(spoofed_text) # emitted when action performed that has text-side equivalent

func _ready() -> void:
	var controller = get_node("/root/Main")
#	connect("item_collided", controller, "pickup_item_collision")
	connect("action_spoofed", controller, "_on_Input_spoofed")


func _physics_process(delta: float) -> void:
	var movement = Vector2( 
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	movement = movement.normalized() * move_speed
	move_and_slide(movement)
	
	if movement.length() > 0:
		last_movement = movement


func add_item(item):
	if item.item_type == Item.Item_Type.KEY:
		if "key" in inventory:
			# add to key count
			inventory["key"].key_count += 1
		else:
			# add key to inventory
			inventory["key"] = item
			inventory["key"].key_count += 1
			add_child(item)
	else:
		inventory[item.name.tolower()] = item
		add_child(item)
	# update display?
	# update inventory string
	_update_inventory_string()


func remove_item(item):
	if item.item_type == Item.Item_Type.KEY:
		if "key" in inventory:
			# add to key count
			inventory["key"].key_count -= 1
			if inventory["key"].key_count == 0:
				# remove key item
				inventory.erase("key")
		else:
			printerr("There weren't any keys in the inventory.")
	item.queue_free()
	# update display?
	# update inventory string
	_update_inventory_string()


func _update_inventory_string():
	var inv_size = inventory.size()
	var current_index = 0
	# reset string
	inventory_as_text = "In your pockets, you have: "
	if inv_size == 0:
		return
	
	for i in inventory:
		if i== "key":
			inventory_as_text += str(inventory["key"].key_count) + " keys"
		else:
			inventory_as_text += i.name
		if current_index < inv_size-1:
			inventory_as_text += ", "
		current_index += 1


func _on_InteractionRange_body_entered(body: Node) -> void:
	if body.is_in_group("items"):
		# pick up item
#		emit_signal("item_collided", body)
		var input_string = "pickup " + body.name
		emit_signal("action_spoofed", input_string)
