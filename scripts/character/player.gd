extends CharacterBody2D


@export var speed = 250  # Movement speed in pixels per second
@onready var crop_manager = get_node("/root/CropManager")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var current_field: Field = null
var selected_crop: String = "carrot"  # Default crop
var looking_direction = "down"

signal interact
signal interact2

#signal plant_crop(crop_type, position)

func _ready() -> void:
    # Add the player to the "Player" group for identification
    load_state()
    #Field.plant_crop.connect(CropManager._on_player_plant_crop)
    # Connect to all fields
    
    
    
    
    # print("Connecting to fields")
    # for field in get_tree().get_nodes_in_group("fields"):
    #     if field is Field:
    #         field.player_entered.connect(_on_field_entered)
    #         field.player_exited.connect(_on_field_exited)
    
    

    
    #plant_crop.connect(CropManager._on_player_plant_crop)




func _input(event: InputEvent) -> void:
    # Check if the interaction key is pressed
    if event.is_action_pressed("interact"):
        interact.emit()
        print(current_field)
        if current_field:
            current_field.try_interact(selected_crop)
        else:
            print("You can only plant on farming fields!")
    if event.is_action_pressed("interact2"):
        interact2.emit()




# func _on_field_entered(field: Field) -> void:
#     print("Field entered: ", field.name)
#     current_field = field

# func _on_field_exited(field: Field) -> void:
#     print("Field exited: ", field.name)
#     if current_field == field:
#         current_field = null




func set_selected_crop(crop_name: String) -> void:
    selected_crop = crop_name


func _physics_process(delta: float) -> void:
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
    # Determine animation prefix (walk or idle)
    var animation_type = "walk" if direction.length() > 0 else "idle"
    
    # Combine animation type with current looking direction
    var animation_name = animation_type + "_" + looking_direction
    
    # Play the animation
    sprite.play(animation_name)


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
