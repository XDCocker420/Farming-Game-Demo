extends AnimatedSprite2D


@onready var timer: Timer = $Timer
var state = 0


func _ready() -> void:
    play("grow 1")
    timer.start()


func _on_timer_timeout() -> void:
    if state == 2:
        queue_free()
    else:
        state += 1
        timer.start()
        
    if state == 1:
        position.y -= 10
        play("grow 2")
    elif state == 2:
        play("grow 3")
