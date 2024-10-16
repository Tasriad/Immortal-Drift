extends "res://scripts/enemy_slime.gd"  # Inherit from the base player script

func chase(delta):
	if player_chase and player == global.active_player:  # Only chase if the detected player is active
		# Calculate the direction to the player's position
		var direction = player.position - position
		
		# Normalize the direction vector
		direction = direction.normalized()

		# Move towards the player's position at the defined speed
		position += direction * speed * delta  # Use delta for frame-rate independent movement

		# Determine which animation to play based on player's relative position
		if abs(direction.x) > abs(direction.y):  # Player is more to the side
			$AnimatedSprite2D.play("small_dragon_walk")
			# Flip the sprite horizontally if the player is to the left
			$AnimatedSprite2D.flip_h = direction.x < 0
		elif direction.y > 0:  # Player is below the character
			$AnimatedSprite2D.play("small_dragon_walk")
		else:  # Player is above the character
			$AnimatedSprite2D.play("small_dragon_walk")
	else:
		# If not chasing or player is not the active one, play the idle animation
		$AnimatedSprite2D.play("small_dragon_idle")	