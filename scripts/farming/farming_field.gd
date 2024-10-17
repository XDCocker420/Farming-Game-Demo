extends Area2D

var player_in_range: CharacterBody2D = null
var is_open = false

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = body as CharacterBody2D
		player_in_range.interact.connect(_on_player_interact)
		player_in_range.interact2.connect(_on_player_interact2)
		print("Player is near the field.")

func _on_body_exited(body: Node) -> void:
	if body == player_in_range:
		player_in_range.interact.disconnect(_on_player_interact)
		player_in_range.interact2.disconnect(_on_player_interact2)
		player_in_range = null
		print("Player left the field area.")

func _on_player_interact() -> void:
	plant_seed()

func _on_player_interact2() -> void:
	harvest()

func plant_seed():
	print("Seed planted!")
	player_in_range.play("plant")
	#$Seed.visible = true
	var mouse_position = get_global_mouse_position()
	var crop_type = get_selected_crop_type()  # Implement this function based on your UI
	get_node("/root/CropManager").plant_crop(crop_type, mouse_position)

func harvest():
	print("Plant harvested!")
	$Seed.play_backwards("grow")
	#$Seed.visible = false

func get_selected_crop_type():
	# Implement this function based on your UI
	# For example, you could have a dropdown menu or a button group
	# that determines the selected crop type
	return "carrot"  # Default crop type for testing purposes