extends Area2D


@onready var carrot: AnimatedSprite2D = $Carrot
@onready var carrot_2: AnimatedSprite2D = $Carrot2
@onready var carrot_3: AnimatedSprite2D = $Carrot3

var in_area: bool = false


func _ready() -> void:
    carrot.visible = false
    carrot_2.visible = false
    carrot_3.visible = false


func _process(delta: float) -> void:
    if in_area and Input.is_action_just_pressed("interact"):
        carrot.visible = true
        carrot_2.visible = true
        carrot_3.visible = true
        carrot.play("grow")
        carrot_2.play("grow")
        carrot_3.play("grow")


func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("Player"):
        in_area = true


func _on_body_exited(body: Node2D) -> void:
    if body.is_in_group("Player"):
        in_area = false
