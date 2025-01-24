extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_attacking: bool = false

func _ready():
	# Connect the animation_finished signal to a callback function
	$AnimatedSprite2D2.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D2_animation_finished"))
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Stop upward movement if the jump button is released and the character is still moving upward
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = 0  # Reduce upward velocity to simulate variable jump height
		
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
		velocity.y = input_direction.y * SPEED  # Add vertical movement
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)  # Decelerate vertically
	
	# Play animations
	if not is_attacking:  # Only change animations if not attacking
		#if is_on_floor():
			if input_direction.x == 0:
				$AnimatedSprite2D2.play("idle")
			else:
				$AnimatedSprite2D2.play("walk")
		#else:
			#$AnimatedSprite2D2.play("jump")  # Play jump animation when in the air
			
	# Handle attack animations (one press, one animation)
	if Input.is_action_just_pressed("attack1") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D2.play("attack1")
	elif Input.is_action_just_pressed("attack2") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D2.play("attack2")
	elif Input.is_action_just_pressed("attack3") and not is_attacking:
		is_attacking = true
		$AnimatedSprite2D2.play("attack3")
		
	move_and_slide()

# Callback function for when an animation finishes
func _on_AnimatedSprite2D2_animation_finished():
	if $AnimatedSprite2D2.animation.begins_with("attack"):
		is_attacking = false
		$AnimatedSprite2D2.play("idle")  # Reset to idle after attack animation

	
