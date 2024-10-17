extends CharacterBody2D

# Movement speed of the ghost
const speed = 100
var current_dir = "none"
# Array to keep track of nearby possessable characters
var nearby_characters = []

func _ready():
	$AnimatedSprite2D.play("ghost_front_idle")  # Default idle animation
	$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	$Area2D.connect("body_exited", Callable(self, "_on_body_exited"))	
	

func _physics_process(delta):
	ghost_movement(delta)  # Handle ghost movement
	handle_possess()  # Handle possession input	
	
func handle_input(delta):
	ghost_movement(delta)  # Call the existing ghost movement function
	

func ghost_movement(delta):
	# Check for input and move the ghost accordingly
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		$AnimatedSprite2D.flip_h = false
		play_animation(true)
		velocity.x = speed
		velocity.y = 0

	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		$AnimatedSprite2D.flip_h = false
		play_animation(true)
		velocity.x = -speed
		velocity.y = 0

	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_animation(true)
		velocity.y = speed
		velocity.x = 0

	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_animation(true)
		velocity.y = -speed
		velocity.x = 0

	else:
		velocity.x = 0
		velocity.y = 0
		play_animation(false)  # Idle animation when not moving

	# Use move_and_slide to apply movement
	move_and_slide()

# Function to play the correct animation based on movement and direction
func play_animation(is_moving):
	if current_dir == "right":
		if is_moving:
			$AnimatedSprite2D.play("ghost_right")
		else:
			$AnimatedSprite2D.play("ghost_right")
	elif current_dir == "left":
		if is_moving:
			$AnimatedSprite2D.play("ghost_left")
		else:
			$AnimatedSprite2D.play("ghost_left")
	elif current_dir == "down":
		if is_moving:
			$AnimatedSprite2D.play("ghost_front")
		else:
			$AnimatedSprite2D.play("ghost_front")
	elif current_dir == "up":
		if is_moving:
			$AnimatedSprite2D.play("ghost_back")
		else:
			$AnimatedSprite2D.play("ghost_back")

# Function to handle characters entering the possession range
func _on_body_entered(body):
	# Check if the body is a character that can be possessed
	if body.has_method("possess"):
		nearby_characters.append(body)

# Function to handle characters leaving the possession range
func _on_body_exited(body):
	# Remove the character from the nearby list
	if body in nearby_characters:
		nearby_characters.erase(body)			
		
# Function to handle possession input
func handle_possess():
	if Input.is_action_just_pressed("possess"):
		print("possession key presses.")
		if nearby_characters.size() > 0:
			# Possess the first character in the list
			var character_to_possess = nearby_characters[0]
			possess_character(character_to_possess)
						
# Function to possess a new character
func possess_character(new_character: Node):
	if global.active_player:
		# Disable the camera of the old active player (if it exists)
		if global.active_player.has_node("world_camera"):
			global.active_player.get_node("world_camera").enabled = false

		global.active_player.queue_free()  # Optionally remove or hide the current active player

	# Set the new character as active
	global.active_player = new_character  
	global.active_player.show()  # Make sure the new character is visible
	global.active_player.position = self.position  # Move the new character to the ghost's current position

	# Enable the new character's camera
	if global.active_player.has_node("world_camera"):
		global.active_player.get_node("world_camera").enabled = true
		#global.active_player.get_node("world_camera").current = true  # Set it as the current camera

	# Finally, hide the ghost
	self.hide()
