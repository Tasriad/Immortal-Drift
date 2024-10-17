extends CharacterBody2D

# Speed at which the character moves
@export var speed = 30
# Boolean to check if the player is being chased
var player_chase = false
# Reference to the player node
var player = null
@export var slime_full_health = 100
@export var slime_attack_damage = 25
var health = slime_full_health
var player_inattack_zone = false
var can_take_damage = true

# Timer for slime attacks
var slime_attack_cooldown = true

# Function that runs every frame, handling movement and animation
func _physics_process(delta):
	_deal_with_damage()
	update_health()
	chase(delta)
	attack_player()

func chase(delta):
	if player_chase and player == global.active_player:  # Only chase if the detected player is the active player
		# Ensure player is valid and alive (not dead or a ghost)
		if global.active_player != null and global.active_player.player_alive:
			# Calculate the direction to the player's position
			var direction = player.position - position
			# Normalize and move towards the player
			direction = direction.normalized()
			position += direction * speed * delta
			# Handle animation logic as before
			if abs(direction.x) > abs(direction.y):
				$AnimatedSprite2D.play("slime_side_walk")
				$AnimatedSprite2D.flip_h = direction.x < 0
			elif direction.y > 0:
				$AnimatedSprite2D.play("slime_front_walk")
			else:
				$AnimatedSprite2D.play("slime_back_walk")
		else:
			# Stop chasing if the player is no longer valid (e.g., dead or ghost)
			player_chase = false
	else:
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

func enemy():  # Base method to mark as enemy
	pass

# Called when player enters the slime's attack zone
func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player") and body == global.active_player:  # Only trigger if the active player enters
		player_inattack_zone = true
		# Initiate the attack logic
		if slime_attack_cooldown:
			attack_player()

# Called when player exits the slime's attack zone
func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player") and body == global.active_player:  # Only trigger if the active player exits
		player_inattack_zone = false

# Function to deal with slime's attack logic
func attack_player():
	if player_inattack_zone and slime_attack_cooldown:
        # Ensure the active player is valid and can take damage before attacking
		if global.active_player.has_method("take_damage") and global.active_player != null:
			global.active_player.take_damage(slime_attack_damage)
			$attack_cooldown_timer.start()  # Start cooldown timer for the next attack
			slime_attack_cooldown = false
		else:
			player_inattack_zone = false  # Reset attack zone if the player is no longer valid



# Called when the cooldown timer times out, allowing the slime to attack again
func _on_attack_cooldown_timer_timeout():
	slime_attack_cooldown = true
	print("Slime can attack again")

func _deal_with_damage():
	# Enemy damage logic (if player attacks slime)
	if player_inattack_zone and global.player_current_attack == true:
		if can_take_damage:
			health -= 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("slime health=", health)
			if health <= 0:
				self.queue_free()

# Reset damage cooldown
func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	healthbar.visible = health < slime_full_health  # Show health bar only when health is below full

func reset_attack_target():
	player_inattack_zone = false
	player_chase = false
	player = null  # Reset the current player reference
	print("Slime has stopped targeting the player")

