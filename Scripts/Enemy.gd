extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var ziplandi = false
var dusuluyor = false
var vuruyormu = false
var hareket_edebilirmi = true

func _physics_process(delta):
	var konum = global_position
	
	if Input.is_action_just_pressed("Attack2"):
		vuruyormu = true
		hareket_edebilirmi = false
		play_random_attack_animation()
		print("Vuruyor")

	if not is_on_floor():
		velocity.y += gravity * delta
		print("yatay hiz ", velocity.y)

	if Input.is_action_just_pressed("Jump2") and is_on_floor() and not vuruyormu:
		velocity.y = JUMP_VELOCITY
		print("dikey hiz ", velocity.y)
		sprite.play("Jump")
		ziplandi = true
		print("ziplandi")

	if velocity.y > 0 and not is_on_floor() and not vuruyormu:
		if not dusuluyor:
			sprite.play("Fall")
			dusuluyor = true
			print("Dusuluyor")

	if velocity.y == 0 and is_on_floor() and dusuluyor and not vuruyormu:
		sprite.play("Fall_On_Ground")
		dusuluyor = false
		print("dusuldu")

	var direction = Input.get_action_strength("Right2") - Input.get_action_strength("Left2")

	if direction != 0 and not ziplandi and hareket_edebilirmi and not vuruyormu:
		if Input.is_action_pressed("Run2"):
			sprite.play("Run")
			velocity.x = direction * SPEED * 1.5
			print("yatay hiz ", velocity.x)
		else:
			sprite.play("Walk")
			velocity.x = direction * SPEED
			print("Yön ", direction)
		if direction == 1:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	elif direction == 0:
		velocity.x = lerp(velocity.x, 0.0, 10 * delta)
		if abs(velocity.x) < 0.001:  # Hız çok küçükse sıfırla
			velocity.x = 0
		print("yatay hiz ", velocity.x)
		if hareket_edebilirmi and not vuruyormu:
			sprite.play("Idle")
	if not vuruyormu:
		move_and_slide()

func play_random_attack_animation():
	var attack_animations = ["Attack1", "Attack2", "Attack3"]
	var random_index = randi() % attack_animations.size()
	var random_animation = attack_animations[random_index]
	sprite.play(random_animation)

func _on_animated_sprite_2d_animation_finished():
	print("Animation finished: ", sprite.animation)
	
	if sprite.animation == "Attack1" or sprite.animation == "Attack2" or sprite.animation == "Attack3":
		hareket_edebilirmi = true
		vuruyormu = false
		
	if sprite.animation == "Jump":
		ziplandi = false
		hareket_edebilirmi = true
		print("ziplama bitti")
		
	if sprite.animation == "Fall_On_Ground":
		dusuluyor = false
		hareket_edebilirmi = true

func _on_area_2d_body_entered(body):
	pass
