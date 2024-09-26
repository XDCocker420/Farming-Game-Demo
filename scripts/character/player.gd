extends CharacterBody2D

@export var speed = 250  # Movement speed in pixels per second

func _physics_process(delta):
	velocity = Vector2.ZERO  # Reset velocity each frame

	# Input handling for WASD keys
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	#	$AnimatedSprite2D.play("walk_right")
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	#	$AnimatedSprite2D.play("walk_left")
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	#	$AnimatedSprite2D.play("walk_down")
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	#	$AnimatedSprite2D.play("walk_up")
	#else:
	#	$AnimatedSprite2D.play("idle")

	# Normalize velocity to prevent faster diagonal movement
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	# Move the player by updating position
	position += velocity * delta

	# Animation handling
	update_animation(velocity)
	move_and_slide()


func update_animation(speedV):
	if speedV.x > 0:
		$AnimatedSprite2D.play("walk_right")
	elif speedV.x < 0:
		$AnimatedSprite2D.play("walk_left")
	elif speedV.y > 0:
		$AnimatedSprite2D.play("walk_down")
	elif speedV.y < 0:
		$AnimatedSprite2D.play("walk_up")
	else:
		$AnimatedSprite2D.play("idle")
