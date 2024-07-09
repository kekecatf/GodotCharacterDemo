extends char
@onready var enemy_sprite = $AnimatedSprite2D


func _physics_process(delta):
	
	if Input.is_action_just_pressed("Attack"):
		vuruyormu = true
		hareket_edebilirmi = false
		play_random_attack_animation()
		print("Vuruyor")

	if not is_on_floor():
		velocity.y += gravity * delta
		print("yatay hiz ", velocity.y)


	if velocity.y > 0 and not is_on_floor() and not vuruyormu:
		if not dusuluyor:
			enemy_sprite.play("Fall")
			dusuluyor = true
			print("Dusuluyor")

	if velocity.y == 0 and is_on_floor() and dusuluyor and not vuruyormu:
		enemy_sprite.play("Fall_On_Ground")
		dusuluyor = false
		print("dusuldu")

	var direction = Input.get_action_strength("Right") - Input.get_action_strength("Left")

	if direction != 0 and hareket_edebilirmi and not vuruyormu:
		if Input.is_action_pressed("Run"):
			enemy_sprite.play("Run")
			velocity.x = direction * SPEED * 1.5
			print("yatay hiz ", velocity.x)
		else:
			enemy_sprite.play("Walk")
			velocity.x = direction * SPEED
			print("Yön ", direction)
		if direction == 1:
			enemy_sprite.flip_h = false
		else:
			enemy_sprite.flip_h = true
	elif direction == 0:
		velocity.x = lerp(velocity.x, 0.0, 10 * delta)
		if abs(velocity.x) < 0.001:  # Hız çok küçükse sıfırla
			velocity.x = 0
		print("yatay hiz ", velocity.x)
		if hareket_edebilirmi and not vuruyormu:
			enemy_sprite.play("Idle")
	if not vuruyormu:
		move_and_slide()

func play_random_attack_animation():
	var attack_animations = ["Attack1", "Attack2", "Attack3"]
	var random_index = randi() % attack_animations.size()
	var random_animation = attack_animations[random_index]
	enemy_sprite.play(random_animation)

func _on_animated_sprite_2d_animation_finished():
	print("Animation finished: ", enemy_sprite.animation)
	
	if enemy_sprite.animation == "Attack1" or enemy_sprite.animation == "Attack2" or enemy_sprite.animation == "Attack3":
		hareket_edebilirmi = true
		vuruyormu = false
		
		
	if enemy_sprite.animation == "Fall_On_Ground":
		dusuluyor = false
		hareket_edebilirmi = true
