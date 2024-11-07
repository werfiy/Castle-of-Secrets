extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var anim = $AnimatedSprite2D
var is_atacking = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Atackfunc1") and is_on_floor:
		if not is_atacking:
			is_atacking = true
			anim.play("Atack1")

func _on_AtackAnimation_finished():
	is_atacking = false

func _on_Area2D_body_entered(body: Node):
	if is_atacking and body.is_in_group("enemies"):
		body.queue_free()
		 
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("idle")
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	if velocity.y > 0:
		anim.play("fall")




	move_and_slide()
