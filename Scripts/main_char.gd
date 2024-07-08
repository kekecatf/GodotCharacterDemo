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
	if hareket_edebilirmi == false:
		velocity.x = 0
	
	if Input.is_action_just_pressed("Attack"):
		vuruyormu = true
		hareket_edebilirmi = false
		play_random_attack_animation()
		print("Vuruyor")

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor() and vuruyormu == false:
		velocity.y = JUMP_VELOCITY
		sprite.play("Jump")
		ziplandi = true
		print("ziplandi")

	if velocity.y>0 and not is_on_floor() and vuruyormu == false:
		sprite.play("Fall")
		dusuluyor = true
		print("Dusuluyor")

	if velocity.y ==0 and is_on_floor() and dusuluyor ==true and vuruyormu == false:
		sprite.play("Fall_On_Ground")
		print("dusuldu")

	var direction = Input.get_axis("Left", "Right")
	
	if direction and ziplandi == false and vuruyormu == false:
		if Input.is_action_pressed("Run"):
			sprite.play("Run")
			velocity.x = direction * SPEED * 1.5
		else:
			sprite.play("Walk")
			velocity.x = direction * SPEED
		if direction==1:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	
	elif velocity.y==0 and vuruyormu == false:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("Idle")

	move_and_slide()

func play_random_attack_animation():
	var attack_animations = ["Attack1", "Attack2", "Attack3"]
	var random_index = randi() % attack_animations.size()
	var random_animation = attack_animations[random_index]
	sprite.play(random_animation)

func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "Attack1" || "Attack2" || "Attack3":
		hareket_edebilirmi = true
		vuruyormu = false
		
	if sprite.animation == "Jump":
		ziplandi = false
		
	if sprite.animation == "Fall_On_Ground":
		dusuluyor = false

func _on_area_2d_body_entered(body):
	pass
