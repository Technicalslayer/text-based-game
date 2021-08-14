extends KinematicBody2D

export (int) var move_speed = 200

func _physics_process(delta: float) -> void:
	var movement = Vector2( 
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	movement = movement.normalized() * move_speed
	move_and_slide(movement)
