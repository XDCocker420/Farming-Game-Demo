extends CharacterBody2D


@export var speed = 250  # Movement speed in pixels per second
var looking_direction = "down"

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

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
    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    velocity = direction * speed

    if direction.x > 0:
        looking_direction = "right"
    elif direction.x < 0:
        looking_direction = "left"
    elif direction.y > 0:
        looking_direction = "down"
    elif direction.y < 0:
        looking_direction = "up"

    update_animation(direction)
    move_and_slide()
 

func update_animation(direction: Vector2):
    if looking_direction == "right":
        if direction.x > 0:
            sprite.play("walk_right")
        else:
            sprite.play("idle_right")
    elif looking_direction == "left":
        if direction.x < 0:
            sprite.play("walk_left")
        else:
            sprite.play("idle_left")
    elif looking_direction == "down":
        if direction.y > 0:
            sprite.play("walk_down")
        else:
            sprite.play("idle_down")
    elif looking_direction == "up":
        if direction.y < 0:
            sprite.play("walk_up")
        else:
            sprite.play("idle_up")


## SAVE FUNCTIONS
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
