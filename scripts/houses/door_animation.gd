extends AnimatedSprite2D

func open_door():
	$AnimatedSprite2D.play("open")

func close_door():
	$AnimatedSprite2D.play("close")
