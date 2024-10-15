extends CharacterBody2D

# Speed at which the character moves
var speed = 40
# Boolean to check if the player is being chased
var player_chase = false
# Reference to the player node
var player = null
var health=100
var player_inattack_zone=false
var can_take_damage=true

# Function that runs every frame, handling movement and animation
func _physics_process(delta):
	_deal_with_damage()
	update_health()
	if player_inattack_zone and not can_take_damage:
		return
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
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if(body.has_method("player")):
		player_inattack_zone=true


func _on_enemy_hitbox_body_exited(body):
	if(body.has_method("player")):
		player_inattack_zone=false
func _deal_with_damage():
	if player_inattack_zone and global.player_current_attack==true:
		if can_take_damage==true:
			health=health-20
			$take_damage_cooldown.start()
			can_take_damage=false
			print("slime health=",health)
			if(health<=0):
				self.queue_free()


func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage=true
func update_health():
	var healthbar=$healthbar
	healthbar.value=health
	if health>=100:
		healthbar.visible=false
	else:
		healthbar.visible=true
