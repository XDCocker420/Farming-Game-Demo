extends Area2D

# Variable to track if the player is in range
var player_in_range = null
var is_open = false

func _ready():
	# Connect signals for detecting when the player enters or exits the area
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	# Check if the body is the player
	if body.is_in_group("Player"):
		player_in_range = body
		if player_in_range and Input.is_action_just_pressed("ui_accept"):
			open_door()
		print("Player is near the door.")

func _on_body_exited(body):
	# Reset when the player leaves the area
	if body.is_in_group("Player"):
		player_in_range = null
		if player_in_range and Input.is_action_just_pressed("ui_accept"):
			open_door()
		print("Player left the door area.")

func open_door():
	# Implement your door opening logic here
	print("The door opens!")
	# Example: Play an animation or disable collision
	if not is_open:
		$Door.play("open")
		is_open = true
	else:
		$Door.play_backwards("open")
		is_open = false
	
