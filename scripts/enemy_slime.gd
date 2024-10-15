extends CharacterBody2D

# Speed at which the character moves
var speed = 30
# Boolean to check if the player is being chased
var player_chase = false
# Reference to the player node
var player = null
var slime_full_health = 100
var health = slime_full_health
var player_inattack_zone = false
var can_take_damage = true

# Function that runs every frame, handling movement and animation
func _physics_process(delta):
	_deal_with_damage()
	update_health()

	if player_chase and player == global.active_player:  # Only chase if the detected player is active
		# Calculate the direction to the player's position
		var direction = player.position - position
		
		# Normalize the direction vector
		direction = direction.normalized()

		# Move towards the player's position at the defined speed
		position += direction * speed * delta  # Use delta for frame-rate independent movement

		# Determine which animation to play based on player's relative position
		if abs(direction.x) > abs(direction.y):  # Player is more to the side
			$AnimatedSprite2D.play("slime_side_walk")
			# Flip the sprite horizontally if the player is to the left
			$AnimatedSprite2D.flip_h = direction.x < 0
		elif direction.y > 0:  # Player is below the character
			$AnimatedSprite2D.play("slime_front_walk")
		else:  # Player is above the character
			$AnimatedSprite2D.play("slime_back_walk")
	else:
		# If not chasing or player is not the active one, play the idle animation
		$AnimatedSprite2D.play("slime_front_idle")

# Function called when the player enters the detection area
func _on_detection_area_body_entered(body):
	if body.has_method("player"):  # Ensure the detected body has a player method
		player = body
		player_chase = true

# Function called when the player exits the detection area
func _on_detection_area_body_exited(body):
	if body == player:  # Check if the exiting body is the current target player
		player = null
		player_chase = false

func enemy(): # This method must be in every enemy
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player") and body == global.active_player:  # Only trigger if the active player enters
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player") and body == global.active_player:  # Only trigger if the active player exits
		player_inattack_zone = false

func _deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true:
		if can_take_damage:
			health -= 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("slime health=", health)
			if health <= 0:
				self.queue_free()

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	healthbar.visible = health < slime_full_health  # Show health bar only when health is below full
