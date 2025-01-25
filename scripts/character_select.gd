extends Button

@onready var animated_sprite = $AnimatedSprite2D  # AnimatedSprite as a child of the button
@export var character_sprite_path: NodePath     # Path to the character's sprite in the game world

func _ready():
	# Connect signals
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	connect("pressed", Callable(self, "_on_button_pressed"))

func _on_mouse_entered():
	# Play hover animation
	animated_sprite.play("default")

func _on_mouse_exited():
	# Stop hover animation
	animated_sprite.stop()

func _on_button_pressed():
	# Handle character selection
	var character_sprite = get_node(character_sprite_path)
	if character_sprite:
		character_sprite.texture = animated_sprite.frames.get_frame("default", 0)  # Set the character's sprite
