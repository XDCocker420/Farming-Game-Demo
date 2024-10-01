extends CharacterBody2D

@export var speed = 250  # Movement speed in pixels per second

signal interact
signal interact2
signal plant_crop(crop_type, position)

func _ready() -> void:
	# Add the player to the "Player" group for identification
	add_to_group("Player")
	load_state()
	plant_crop.connect(CropManager._on_player_plant_crop)

func _input(event: InputEvent) -> void:
	# Check if the interaction key is pressed
	if event.is_action_pressed("interact"):
		interact.emit()
		var mouse_position = get_global_mouse_position()
		if CropManager.is_farming_field_tile(mouse_position):
			var crop_type = CropManager.get_selected_crop_type()
			plant_crop.emit(crop_type, mouse_position)
		else:
			print("You can only plant on farming fields!")
	if event.is_action_pressed("interact2"):
		interact2.emit()	

func _physics_process(delta):
	velocity = Vector2.ZERO  # Reset velocity each frame

	# Input handling for WASD keys
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	# Normalize velocity to prevent faster diagonal movement
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	# Move the player by updating position
	position += velocity * delta

	# Animation handling
	update_animation(velocity)
	move_and_slide()


func update_animation(speedV):
	if speedV.x > 0:
		$AnimatedSprite2D.play("walk_right")
	elif speedV.x < 0:
		$AnimatedSprite2D.play("walk_left")
	elif speedV.y > 0:
		$AnimatedSprite2D.play("walk_down")
	elif speedV.y < 0:
		$AnimatedSprite2D.play("walk_up")
	else:
		$AnimatedSprite2D.play("idle")
 
func save_state() -> void:
	# Save player's position
	SaveData.data["player_positionX"] = global_position.x
	SaveData.data["player_positionY"] = global_position.y

func load_state() -> void:
	# Load player's position
	if "player_positionX" in SaveData.data || "player_positionY" in SaveData.data:
		print("Player position loaded.")
		global_position = Vector2(
			SaveData.data["player_positionX"],
			SaveData.data["player_positionY"]
		)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# Save player state before the game quits
		save_state()
