extends CharacterBody2D  # Extends the CharacterBody2D class, which provides 2D physics-based movement for the character

const speed = 100  # Constant variable to define movement speed
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")
	
# The physics process function is called every frame to handle physics-related updates
func _physics_process(delta):  
	player_movement(delta)  # Calls the player_movement function to handle character movement

# Function to handle the player's movement
func player_movement(delta): 
	# Check if the right movement key is pressed
	if Input.is_action_pressed("ui_right"):  
		current_dir = "right"
		play_animation(1)
		velocity.x = speed  # Move right by setting the horizontal velocity to the speed value
		velocity.y = 0  # Ensure vertical velocity is zero to prevent diagonal movement
	
	# Check if the left movement key is pressed
	elif Input.is_action_pressed("ui_left"):  
		current_dir = "left"
		play_animation(1)
		velocity.x = -speed  # Move left by setting the horizontal velocity to negative speed
		velocity.y = 0  # Ensure vertical velocity is zero
	
	# Check if the down movement key is pressed
	elif Input.is_action_pressed("ui_down"):  
		current_dir = "down"
		play_animation(1)
		velocity.y = speed  # Move down by setting the vertical velocity to speed
		velocity.x = 0  # Ensure horizontal velocity is zero
	
	# Check if the up movement key is pressed
	elif Input.is_action_pressed("ui_up"): 
		current_dir = "up" 
		play_animation(1)
		velocity.y = -speed  # Move up by setting the vertical velocity to negative speed
		velocity.x = 0  # Ensure horizontal velocity is zero
	
	# If no movement keys are pressed, set the velocity to zero (stop movement)
	else:  
		velocity.x = 0  
		velocity.y = 0
		play_animation(0)  # Call play_animation with '0' to play idle animation

	move_and_slide()  # Apply the velocity and move the character, handling collisions automatically

# Function to play animations based on movement and direction
func play_animation(movement):
	var dir = current_dir
	var animation = $AnimatedSprite2D  # Reference to the animated sprite node
	if dir == "right":
		animation.flip_h = false  # Ensure the sprite is not flipped horizontally
		if movement == 1:
			animation.play("side_walk")  # Play walking animation
		elif movement == 0:
			animation.play("side_idle")  # Play idle animation
	
	elif dir == "left":
		animation.flip_h = true  # Flip sprite horizontally to face left
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			animation.play("side_idle")
	
	elif dir == "down":
		animation.flip_h = false
		if movement == 1:
			animation.play("front_walk")
		elif movement == 0:
			animation.play("front_idle")
	
	elif dir == "up":
		animation.flip_h = false
		if movement == 1:
			animation.play("back_walk")
		elif movement == 0:
			animation.play("back_idle")
