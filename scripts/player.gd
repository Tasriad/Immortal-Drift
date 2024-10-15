extends CharacterBody2D  # Extends the CharacterBody2D class, which provides 2D physics-based movement for the character
var enemy_inattack_range=false
var enemy_attack_cooldown=true
var full_health = 100
var regen_health = 20
var health=full_health
var player_alive=true
const speed = 100  # Constant variable to define movement speed
var current_dir = "none"
var attack_ip=false
var slime_attack_damage = 10

func _ready():
	$AnimatedSprite2D.play("front_idle")
	
# The physics process function is called every frame to handle physics-related updates
func _physics_process(delta):  
	player_movement(delta)  # Calls the player_movement function to handle character movement
	enemy_attack()
	attack()
	#add current camera here
	update_health()
	
	
	if health <=0:
		player_alive=0 #go back to menu or respond
		health=0
		print("Player has been killed")
		self.queue_free()
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
			if attack_ip==false:
				animation.play("side_idle")  # Play idle animation
	
	elif dir == "left":
		animation.flip_h = true  # Flip sprite horizontally to face left
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			if attack_ip==false:
				animation.play("side_idle")
	
	elif dir == "down":
		animation.flip_h = false
		if movement == 1:
			animation.play("front_walk")
		elif movement == 0:
			if attack_ip==false:
				animation.play("front_idle")
	
	elif dir == "up":
		animation.flip_h = false
		if movement == 1:
			animation.play("back_walk")
		elif movement == 0:
			if attack_ip==false:
				animation.play("back_idle")
				
func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D):
	if body.has_method("enemy"):
		enemy_inattack_range=true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range=false
	
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health=health-slime_attack_damage # we have to modify this for more enemies
		enemy_attack_cooldown=false
		$attack_cooldown.start()
		print("player health=",health)
		
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown=true
	
func attack():
	var dir=current_dir
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack=true
		attack_ip=true
		if dir == "right":
			$AnimatedSprite2D.flip_h=false
			$AnimatedSprite2D.play("side_attack")	 
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h=true
			$AnimatedSprite2D.play("side_attack")	 
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")	 
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")	 
			$deal_attack_timer.start()

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack=false
	attack_ip=false
	
func update_health():
	var healthbar=$healthbar
	healthbar.value=health
	if health>=full_health:
		healthbar.visible=false
	else:
		healthbar.visible=true


func _on_regen_time_timeout():
	if health<full_health:
		health=health+regen_health
		if health>full_health:
			health=full_health
	if health<=0:
		health=0
	
