# CropManager.gd
extends Node

const MAX_GROWTH_STAGES = 5

# Load crop properties from a separate script
var crop_properties = preload("res://scripts/farming/crop_properties.gd").CROP_PROPERTIES

var crops = {}  # Dictionary to store all crop data
var update_timer = 0.0
var UPDATE_INTERVAL = 1.0  # Update every second

func _ready():
	load_crops()
	is_time_jump_detected()  # Check for time manipulation

func load_crops():
	var saved_crops = SaveData.data.get("crops", {})
	for crop_id in saved_crops.keys():
		var crop_data = saved_crops[crop_id]
		crops[crop_id] = crop_data
		instantiate_crop(crop_id, crop_data)

func instantiate_crop(crop_id, crop_data):
	var crop_scene = preload("res://scenes/crops/crop.tscn")
	var crop_instance = crop_scene.instantiate()
	crop_instance.position = crop_data["position"]
	crop_instance.crop_id = crop_id
	crop_instance.crop_type = crop_data["crop_type"]
	var growth_stage = calculate_growth_stage(crop_data)
	crop_instance.set_growth_stage(growth_stage)
	add_child(crop_instance)
	crops[crop_id]["instance"] = crop_instance
	crops[crop_id]["growth_stage"] = growth_stage

func _on_crop_request_harvest(crop_id):
	harvest_crop(crop_id)

func _on_player_plant_crop(crop_type, position):
	plant_crop(crop_type, position)

func _process(delta):
	update_timer += delta
	if update_timer >= UPDATE_INTERVAL:
		update_all_crops()
		update_timer = 0.0

func update_all_crops():
	var current_time = Time.get_unix_time_from_system()
	for crop_id in crops.keys():
		var crop_data = crops[crop_id]
		var elapsed_time = current_time - crop_data["plant_time"]
		var new_growth_stage = calculate_growth_stage(crop_data, elapsed_time)
		if new_growth_stage != crop_data["growth_stage"]:
			crop_data["growth_stage"] = new_growth_stage
			var crop_instance = crop_data["instance"]
			if crop_instance:
				crop_instance.set_growth_stage(new_growth_stage)
	SaveData.data["crops"] = crops

func calculate_growth_stage(crop_data, elapsed_time = null):
	if elapsed_time == null:
		elapsed_time = Time.get_unix_time_from_system() - crop_data["plant_time"]
	var crop_type = crop_data["crop_type"]
	var total_growth_time = get_total_growth_time(crop_type)
	var max_stages = crop_properties.get(crop_type, {}).get("max_growth_stages", MAX_GROWTH_STAGES)
	var growth_percent = min(elapsed_time / total_growth_time, 1.0)
	var growth_stage = floor(growth_percent * max_stages)
	return growth_stage

func get_total_growth_time(crop_type):
	return crop_properties.get(crop_type, {}).get("growth_time", 60)

func plant_crop(crop_type, position):
	var crop_id = generate_unique_crop_id()
	var crop_data = {
		"crop_type": crop_type,
		"plant_time": Time.get_unix_time_from_system(),
		"position": position,
		"growth_stage": 0
	}
	crops[crop_id] = crop_data
	SaveData.data["crops"][crop_id] = crop_data
	instantiate_crop(crop_id, crop_data)

func generate_unique_crop_id():
	return str(Time.get_unix_time_from_system()) + "_" + str(randi())

func harvest_crop(crop_id):
	var crop_data = crops.get(crop_id)
	if crop_data:
		# Handle harvesting logic (e.g., give resources to the player)
		var crop_instance = crop_data.get("instance")
		if crop_instance:
			crop_instance.queue_free()
		crops.erase(crop_id)
		SaveData.data["crops"].erase(crop_id)

func is_time_jump_detected():
	var last_saved_time = SaveData.data.get("last_saved_time", Time.get_unix_time_from_system())
	var current_time = Time.get_unix_time_from_system()
	var time_difference = current_time - last_saved_time
	var MAX_ALLOWED_TIME_DIFFERENCE = 86400  # 24 hours in seconds
	if time_difference < 0 or time_difference > MAX_ALLOWED_TIME_DIFFERENCE:
		# Handle the time jump (e.g., cap the growth, warn the player)
		print("Time jump detected!")
		# Adjust plant_time to prevent instant growth
		for crop_id in crops.keys():
			var crop_data = crops[crop_id]
			crop_data["plant_time"] += time_difference
	SaveData.data["last_saved_time"] = current_time

func is_farming_field_tile(position):
	var tilemap = get_node("/root/MainScene/TileMap")  # Adjust the path to your TileMap
	var local_position = tilemap.to_local(position)
	var tilemap_position = tilemap.local_to_map(local_position)

	# Get the layer index (assuming your farming fields are on a specific layer)
	var layer_index = tilemap.get_layer_index("FarmingLayer")  # Replace with your layer name

	if layer_index == -1:
		print("Layer 'FarmingLayer' not found.")
		return false

	# Get the tile data at the specified position and layer
	var tile_data = tilemap.get_cell_tile_data(layer_index, tilemap_position)

	if tile_data:
		# Get the tile ID (source ID)
		var tile_id = tile_data.get_source_id()
		var tileset = tilemap.tileset

		# Get the TileSet source
		var source_id = tile_data.get_tileset_source_id()
		var tile_source = tileset.get_source(source_id)

		if tile_source:
			var tile_definition = tile_source.tiles[tile_id]

			if tile_definition:
				# Access the custom data
				var custom_data = tile_definition.custom_data
				if custom_data.has("is_farming_field"):
					return custom_data["is_farming_field"]
	return false

func _set_selected_crop_type(crop_type):
	pass
