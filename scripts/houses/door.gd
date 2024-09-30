extends Area2D

var player_in_range: CharacterBody2D = null
var is_open = false

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	$button.visible = false

func _on_body_entered(body: Node) -> void:

	if body.is_in_group("Player"):
		player_in_range = body as CharacterBody2D
		player_in_range.interact.connect(_on_player_interact)
		print("Player is near the door.")

		#Button
		$button.visible = true
		$button.play('default')

func _on_body_exited(body: Node) -> void:
	if body == player_in_range:
		player_in_range.interact.disconnect(_on_player_interact)
		player_in_range = null
		print("Player left the door area.")
		
		#Button
		$button.visible = false
		$button.stop()

func _on_player_interact() -> void:
	open_door()

func open_door():
	if !is_open:
		print("The door opens!")
		$Door.play("open")
		is_open = true
	else:
		print("The door closes!")
		$Door.play_backwards("open")
		is_open = false
	
