extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var ziplandi = false
var dusuluyor = false
var vuruyormu = false
var hareket_edebilirmi = true
var attack_in_progress = false

func _physics_process(delta):
	if Input.is_action_just_pressed("Attack2") and not attack_in_progress:
		vuruyormu = true
		hareket_edebilirmi = false
		play_random_attack_animation()
		attack_in_progress = true


	if not is_on_floor():
		velocity.y += gravity * delta


	if Input.is_action_just_pressed("Jump2") and is_on_floor() and not vuruyormu:
		velocity.y = JUMP_VELOCITY

		sprite.play("Jump")
		ziplandi = true
		hareket_edebilirmi = false


	if velocity.y > 0 and not is_on_floor() and not vuruyormu:
		if not dusuluyor:
			sprite.play("Fall")
			dusuluyor = true


	if velocity.y == 0 and is_on_floor() and dusuluyor and not vuruyormu:
		sprite.play("Fall_On_Ground")
		dusuluyor = false
		hareket_edebilirmi = true


	var direction = Input.get_action_strength("Right2") - Input.get_action_strength("Left2")

	if direction != 0 and hareket_edebilirmi and not vuruyormu:
		if Input.is_action_pressed("Run2"):
			sprite.play("Run")
			velocity.x = direction * SPEED * 1.5

		else:
			sprite.play("Walk")
			velocity.x = direction * SPEED

		if direction == 1:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	elif direction == 0:
		velocity.x = lerp(velocity.x, 0.0, 10 * delta)
		if abs(velocity.x) < 0.001:  # Hız çok küçükse sıfırla
			velocity.x = 0

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

	
	if sprite.animation == "Attack1" or sprite.animation == "Attack2" or sprite.animation == "Attack3":
		hareket_edebilirmi = true
		vuruyormu = false
		attack_in_progress = false
		
	if sprite.animation == "Jump":
		ziplandi = false
		hareket_edebilirmi = true
		
	if sprite.animation == "Fall_On_Ground":
		dusuluyor = false
		hareket_edebilirmi = true

