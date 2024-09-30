extends Area2D

# Variable to track the player when in range
var player_in_range: CharacterBody2D = null
var is_open = false

func _ready() -> void:
# Connect signals for detecting when the player enters or exits the area
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
# Check if the body is the player
	if body.is_in_group("Player"):
		player_in_range = body as CharacterBody2D
# Connect to the player's interact signal
		player_in_range.interact.connect(_on_player_interact)
		print("Player is near the door.")

func _on_body_exited(body: Node) -> void:
	# Check if the body is the player
	if body == player_in_range:
		# Disconnect from the player's interact signal
		player_in_range.interact.disconnect(_on_player_interact)
		player_in_range = null
		print("Player left the door area.")

func _on_player_interact() -> void:
	# Called when the player presses the interaction key
	open_door()

func open_door():
	# Implement your door opening logic here
	if !is_open:
		print("The door opens!")
		$Door.play("open")
		is_open = true
	else:
		print("The door closes!")
		$Door.play_backwards("open")
		is_open = false
	
