extends AnimatedSprite2D


@onready var timer: Timer = $Timer
var state = 0


func _ready() -> void:
	play("grow 1")
	position = Vector2(33, -30)
	timer.start()


func _on_timer_timeout() -> void:
	if state == 2:
		queue_free()
	else:
		state += 1
		timer.start()
		
	if state == 1:
		position.y -= 5
		play("grow 2")
	elif state == 2:
		play("grow 3")
