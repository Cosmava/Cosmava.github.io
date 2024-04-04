extends CharacterBody3D


var SPEED = Global.player_speed
const JUMP_VELOCITY = 0
var mouse_sens = 0.2
var lerp_speed = 5.0

var has_shotgun = false
var can_throw_shotgun = false
var can_shoot = true
var damage = 50
var dead = false

var ammo = 50
var shotgun_ammo = 5

var direction = Vector3.ZERO

@onready var aimCast = $Camera3D/RayCast3D
@onready var animated_sprited_2d = $CanvasLayer/Guns/Apple
@onready var head_bob = $Camera3D/CameraBob
@onready var shotgunAimCast = $Camera3D/ShotgunRayCast

@onready var explosion = preload("res://Scenes/Explosion.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if get_tree().current_scene.name == "Tutorial":
		$CanvasLayer/AmmoCount.hide()
		$CanvasLayer/Health.hide()
		$CanvasLayer/Guns.hide()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x * Global.mouse_sens))

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _process(_delta):
	SPEED = Global.player_speed
	if Input.is_action_just_pressed("Pause"):
		if get_tree().current_scene.name == "World":
			MusicPlayer.resume_menu_music()
		$"../pauseMenu/PauseMenu".visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		$"../pauseMenu/PauseMenu/MarginContainer/VBoxContainer/PlayButton".grab_focus()
	$CanvasLayer/Health.text = "Health: " + str(Global.player_health)
	
	if Input.is_action_pressed("shoot"):
		if ammo > 0:
			shoot()
	
	if has_shotgun:
		if Input.is_action_just_pressed("secondary"):
			if shotgun_ammo > 0:
				throw_shotgun()
		if shotgun_ammo == 0:
			$CanvasLayer/Guns/Shotgun.hide()
		else:
			$CanvasLayer/Guns/Shotgun.show()



func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY 

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta*lerp_speed)
	
	if direction:
		velocity.x = direction.x * Global.player_speed
		velocity.z = direction.z * Global.player_speed
	else:
		velocity.x = move_toward(velocity.x, 0, Global.player_speed)
		velocity.z = move_toward(velocity.z, 0, Global.player_speed)
		
	if  input_dir == Vector2(0, 0):
		head_bob.speed_scale = 0.2
	else:
		head_bob.speed_scale = 0.4


	move_and_slide()

func shoot():
	$CanvasLayer/Guns/Apple.speed_scale = Global.player_attack_speed
	if !can_shoot:
		return
	can_shoot = false
	$CanvasLayer/Guns/Apple.play("Shoot")
	if aimCast.is_colliding ():
		var target = aimCast.get_collider()
		if target.is_in_group("Enemy"):
			MusicPlayer.play_hitsound()
			target.health -= damage


func throw_shotgun():
	if !can_throw_shotgun:
		return
	can_throw_shotgun = false
	$CanvasLayer/Guns/Shotgun.play("ShotgunShoot")


func _on_level_change_area_entered(_area):
	get_tree().change_scene_to_file("res://Scenes/TheHorder.tscn")


func _on_apple_animation_finished():
	can_shoot = true
	ammo -= 1
	$CanvasLayer/AmmoCount.text = "AMMO: " + str(ammo)
	$CanvasLayer/Guns/Apple.play("Idle")

func _on_area_3d_area_entered(area):
	$CanvasLayer/Guns.visible = true
	if area.is_in_group("Ammo"):
		if has_shotgun:
			shotgun_ammo += randi_range(0, 2)
			$CanvasLayer/ShotgunAmmo.text = "SECONDARY: " + str(shotgun_ammo)
		ammo += randi_range(15, 35)
		area.get_parent().queue_free()
		$CanvasLayer/AmmoCount.text = "AMMO: " + str(ammo)
	elif area.is_in_group("Shotgun"):
		has_shotgun = true
		can_throw_shotgun = true
		$CanvasLayer/ShotgunAmmo.show()
		$CanvasLayer/Guns/Shotgun.visible = true
		area.get_parent().queue_free()
		$"../CanvasLayer/BossText".hide()
		$"../CanvasLayer/ShotgunTutorial".show()
		
		await get_tree().create_timer(5).timeout
		
		$"../CanvasLayer/ShotgunTutorial".hide()


func _on_shotgun_animation_finished():
	can_throw_shotgun = true
	if shotgun_ammo == 1:
		$CanvasLayer/Guns/Shotgun.hide()
	$CanvasLayer/Guns/Shotgun.play("Idle")
	var pos = shotgunAimCast.get_collision_point()
	var obj = explosion.instantiate()
	$"..".add_child(obj)
	obj.position = pos
	shotgun_ammo -= 1
	$CanvasLayer/ShotgunAmmo.text = "SECONDARY: " + str(shotgun_ammo)
