extends KinematicBody2D

export (int) var move_speed = 200

var inventory = {} # key: item name, value: node
var inventory_as_text: String = "In your pockets, you have: "


func _physics_process(delta: float) -> void:
	var movement = Vector2( 
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	movement = movement.normalized() * move_speed
	move_and_slide(movement)


func add_item(item):
	if item.item_type == Item.Item_Type.KEY:
		if "key" in inventory:
			# add to key count
			inventory["key"].count += 1
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
