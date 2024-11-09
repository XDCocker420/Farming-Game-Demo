extends Node

var fields: Array[Node] = []
var available_crops: Dictionary = {}
@export var spawn_carrot = load("res://scenes/structures/carrot.tscn")

func _ready():
    # Load all crop types
    load_crop_types()
    # Get all field references
    get_fields()

func _process(delta):
    #update_all_crops(delta)
    pass

func load_crop_types():
    # Load crop definitions from configuration
    var config = ConfigFile.new()
    config.load("res://scripts/farming/crops_config.cfg")
    for crop_name in config.get_sections():
        var crop = Crop.new()
        crop.crop_name = crop_name
        crop.growth_time = config.get_value(crop_name, "growth_time")
        crop.growth_stages = config.get_value(crop_name, "growth_stages")
        crop.value = config.get_value(crop_name, "value")
        available_crops[crop_name] = crop

func get_fields():
    # Find all Field nodes in the scene
    fields = get_tree().get_nodes_in_group("fields")

func update_all_crops(delta):
    for field in fields:
        if field.current_crop:
            update_crop_growth(field, delta)

func update_crop_growth(field: Field, delta: float):
    var crop_data = field.current_crop
        # Calculate growth progress
    var growth_rate = 1.0 / crop_data.crop_type.growth_time
    crop_data.growth_progress += delta * growth_rate
        
        # Update growth stage
    var new_stage = floor(crop_data.growth_progress * 
        crop_data.crop_type.growth_stages)
    if new_stage != crop_data.current_stage:
        crop_data.current_stage = new_stage
        field.update_crop_appearance()

func plant_crop(field: Field, crop_name: String) -> bool:
    print("Planting crop: ", crop_name)
    
    if field.can_plant() and crop_name in available_crops:
        return field.plant_crop(available_crops[crop_name])
    return false

func harvest_crop(field: Field) -> CropData:
    return field.harvest()

func get_crop_type(crop_name: String) -> Crop:
    return available_crops["wheat"]
