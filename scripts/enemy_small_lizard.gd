extends "res://scripts/enemy_small_dragon.gd"  # Inherit from the base player script

@onready var hitsound1=$AudioStreamPlayer2D
func chase(delta):
	# If the slime is not attacking, handle movement and chase animations
	if not attacking:  
		if player_chase and player == global.active_player:  # Only chase if the detected player is active
			var direction = player.position - position
			direction = direction.normalized()
			position += direction * speed * delta  # Use delta for frame-rate independent movement

			# Determine which animation to play based on player's relative position
			if abs(direction.x) > abs(direction.y):  # Player is more to the side
				$AnimatedSprite2D.play("small_lizard_walk")
				$AnimatedSprite2D.flip_h = direction.x < 0
			elif direction.y > 0:  # Player is below the character
				$AnimatedSprite2D.play("small_lizard_walk")
			else:  # Player is above the character
				$AnimatedSprite2D.play("small_lizard_walk")
		else:
			$AnimatedSprite2D.play("small_lizard_idle")
			

# Function to deal with slime's attack logic
func attack_player():
	if player_inattack_zone and slime_attack_cooldown and not attacking:  # Only attack if not currently attacking
		if global.active_player.has_method("take_damage") and global.active_player != null:
			attacking = true  # Set the attacking state to true
			$AnimatedSprite2D.play("small_lizard_attack")
			hitsound1.play()  # Play the attack sound
			global.active_player.take_damage(slime_attack_damage)
			$attack_cooldown_timer.start()  # Start cooldown timer for the next attack
			slime_attack_cooldown = false
		else:
			player_inattack_zone = false  # Reset attack zone if the player is no longer valid

# Called when player exits the slime's attack zone
func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player") and body == global.active_player:  # Check if the exiting body is the active player
		player_inattack_zone = false  # Reset the attack zone
		if attacking:  # If we were attacking, stop attacking immediately
			attacking = false  # Allow transition back to chasing/idle
			$AnimatedSprite2D.play("small_lizard_idle")  # Optionally, reset to idle or walking state

