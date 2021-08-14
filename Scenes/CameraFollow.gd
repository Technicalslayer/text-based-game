extends Camera2D

var target = null

func _ready() -> void:
	target = find_node("Player")

func _physics_process(delta: float) -> void:
	if target:
		global_position = target.global_position
