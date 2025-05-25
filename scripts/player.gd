extends CharacterBody2D

var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_attacking: bool = false

func _ready():
	# Connect the animation_finished signal to a callback function
	$AnimatedSprite2D2.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D2_animation_finished"))
	
func _physics_process(delta: float) -> void:
	player_movement(delta)
	enemy_attack()
	attack()
	
	if health <= 0:
		player_alive = false
		health = 0
		print("player has been killed")
		$AnimatedSprite2D2.play("death")
		self.queue_free()

func player_movement(delta: float):
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
			if input_direction.x == 0 and is_attacking == false:
				$AnimatedSprite2D2.play("idle")
			else:
				$AnimatedSprite2D2.play("walk")
		#else:
			#$AnimatedSprite2D2.play("jump")  # Play jump animation when in the air
			
	# Handle attack animations (one press, one animation)
	#if Input.is_action_just_pressed("attack1") and not is_attacking:
		#is_attacking = true
		#$AnimatedSprite2D2.play("attack1")
	#elif Input.is_action_just_pressed("attack2") and not is_attacking:
		#is_attacking = true
		#$AnimatedSprite2D2.play("attack2")
	#elif Input.is_action_just_pressed("attack3") and not is_attacking:
		#is_attacking = true
		#$AnimatedSprite2D2.play("attack3")
		
	move_and_slide()

func player():
	pass

# Callback function for when an animation finishes
func _on_AnimatedSprite2D2_animation_finished():
	if $AnimatedSprite2D2.animation.begins_with("attack"):
		is_attacking = false
		$AnimatedSprite2D2.play("idle")  # Reset to idle after attack animation

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = true
		

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = false
		
func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	
func attack():
	#var dir = input_direction
	
	# Handle attack animations (one press, one animation)
	if Input.is_action_just_pressed("attack1") and not is_attacking:
		global.player_current_attack = true
		is_attacking = true
		$AnimatedSprite2D2.play("attack1")
		$deal_attack_timer.start()
	elif Input.is_action_just_pressed("attack2") and not is_attacking:
		global.player_current_attack = true
		is_attacking = true
		$AnimatedSprite2D2.play("attack2")
		$deal_attack_timer.start()
	elif Input.is_action_just_pressed("attack3") and not is_attacking:
		global.player_current_attack = true
		is_attacking = true
		$AnimatedSprite2D2.play("attack3")
		$deal_attack_timer.start()
		

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	is_attacking = false
