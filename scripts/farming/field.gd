extends Area2D


var in_area: bool = false
@export var spawn_carrot = preload("res://scenes/structures/carrot.tscn")


func _ready() -> void:
    spawn()


func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("Player"):
        in_area = true


func _on_body_exited(body: Node2D) -> void:
    if body.is_in_group("Player"):
        in_area = false


func spawn() -> void:
    var carrot = spawn_carrot.instantiate()
    add_child(carrot)
