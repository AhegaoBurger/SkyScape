extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get input direction
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Flip the sprite based on movement direction
	if input_direction.x > 0:  # Moving right
		$AnimatedSprite2D2.flip_h = false
	elif input_direction.x < 0:  # Moving left
		$AnimatedSprite2D2.flip_h = true
	
	# Get the input direction and handle the movement/deceleration.
	if input_direction:
		velocity.x = input_direction.x * SPEED
		#velocity.y = input_direction.y * SPEED  # Add vertical movement
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.y = move_toward(velocity.y, 0, SPEED)  # Decelerate vertically
	
	# Play animations
	if is_on_floor():
		if input_direction.x == 0 :
			$AnimatedSprite2D2.play("idle")
		else:
			$AnimatedSprite2D2.play("walk")
	else:
		$AnimatedSprite2D2.play("jump")
			

	move_and_slide()
