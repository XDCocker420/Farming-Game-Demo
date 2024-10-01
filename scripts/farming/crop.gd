# Crop.gd
extends Node2D

var crop_id
var crop_type
var growth_stage = 0

# Load crop properties
var crop_properties = preload("res://scripts/farming/crop_properties.gd").CROP_PROPERTIES

func set_growth_stage(stage):
    if stage != growth_stage:
        growth_stage = stage
        update_visual()

func update_visual():
    var crop_props = crop_properties.get(crop_type, {})
    var texture_path = "%sstage_%d.png" % [crop_props.get("texture_path", ""), growth_stage]
    var sprite = $Sprite  # Adjust this path to your sprite node
    sprite.texture = load(texture_path)

func _on_Area2D_input_event(_viewport, event, _shape_idx):
    if event.is_action_pressed("harvest_crop"):
        var crop_props = crop_properties.get(crop_type, {})
        var max_stages = crop_props.get("max_growth_stages", CropManager.MAX_GROWTH_STAGES)
        if growth_stage >= max_stages:
            if CropManager.is_farming_field_tile(global_position):
                emit_signal("request_harvest", crop_id)
            else:
                print("You can only harvest on farming fields!")

