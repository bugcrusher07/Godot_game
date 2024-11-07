extends CharacterBody3D

signal hit

@export var speed = 200;
@export var fall_accelaration = 75;
@export var jump_impulse = 40;
@export var bounce_impulse = 20;

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_just_pressed("forward"):
		direction.z += -1
	if Input.is_action_just_pressed("backward"):
		direction.z += 1
	if Input.is_action_just_pressed("left"):
		direction.x += -1
	if Input.is_action_just_pressed("right"):
		direction.x += 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
	
	
	target_velocity.z = direction.z * speed
	target_velocity.x = direction.x * speed
	
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_accelaration * delta)
	
	
	velocity = target_velocity
	
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse;
	
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index);
		
		if collision.get_collider() == null:
			continue;
		if collision.get_collider().is_in_group("enemy"):
			var enemy_collision = collision.get_collider()
			
			if Vector3.UP.dot(collision.get_normal())>0.1:
			#if collision.get_normal().y > 0.7:	
				enemy_collision.squash()
				target_velocity.y = bounce_impulse
				break
		
	
	move_and_slide()
	

func _on_enemy_detector_area_entered(area):
	pass # Replace with function body.




func die():
	hit.emit()
	queue_free()

func _on_enemy_detector_body_entered(body):
	die()	
	
