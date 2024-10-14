extends CharacterBody2D

# Speed at which the character moves
var speed = 40
# Boolean to check if the player is being chased
var player_chase = false
# Reference to the player node
var player = null

# Function that runs every frame, handling movement and animation
func _physics_process(delta):
	if player_chase:
		# Calculate the direction to the player's position
		var direction = player.position - position
		
		# Move towards the player's position at the defined speed
		position += direction / speed

		# Determine which animation to play based on player's relative position
		if abs(direction.x) > abs(direction.y):  # Player is more to the side
			$AnimatedSprite2D.play("slime_side_walk")
			# Flip the sprite horizontally if the player is to the left
			if direction.x < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		elif direction.y > 0:  # Player is below the character
			$AnimatedSprite2D.play("slime_front_walk")
		else:  # Player is above the character
			$AnimatedSprite2D.play("slime_back_walk")

	else:
		# If not chasing, play the idle animation
		$AnimatedSprite2D.play("idle")

# Function called when the player enters the detection area
# This starts the chase by setting the player reference and enabling chase mode
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true

# Function called when the player exits the detection area
# This stops the chase by clearing the player reference and disabling chase mode
func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
