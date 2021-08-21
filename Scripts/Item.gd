extends StaticBody2D
class_name Item

enum Item_Type {KEY, AMMO, POTION} # placeholder types
export (String) var description = ""
export (Item_Type) var item_type = Item_Type.KEY
var key_count = 0 # used to keep track of the number of keys the player has
