extends Node3D

@onready var enemy = preload("res://Scenes/bad_guy.tscn")
@onready var ammo = preload("res://Scenes/ammo.tscn")
@onready var shotgun = preload("res://Scenes/shotgun.tscn")

@onready var enemy_spawn_positions = $EnemySpawnPositions
@onready var currentWave = $CanvasLayer/CurrentWave
@onready var numberOfEnemies = $CanvasLayer/NumberOfEnemies
@onready var ammo_spawn_positions = $AmmoSpawnPositions
@onready var upgrades_menu = $UpgradesMenu/Control

var enemiesNum = 0

var wave = 1

var possibleEnemyPoints : Array
var possibleAmmoPoints : Array

var spawning : bool
var waveOver = false

var ammoSpawnTime = randi_range(10, 25)

var spawnTime = 5
var spawnNum = 2
var waveTime = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player_health = Global.player_max_health
	Global.player_attack_speed = 1
	Global.player_speed = 15
	MusicPlayer.play_battle_music()
	possibleEnemyPoints = enemy_spawn_positions.get_children()
	possibleAmmoPoints = ammo_spawn_positions.get_children()
	
	spawning = true
	$WaveTimer.start(waveTime)
	$SpawnTimer.start(spawnTime)
	$AmmoSpawnTimer.start(ammoSpawnTime)
	for i in range(spawnNum):
		if spawning:
			var spawnPos = possibleEnemyPoints.pick_random()
			var obj = enemy.instantiate()
			add_child(obj)
			obj.position = spawnPos.position
			await get_tree().create_timer(0.5).timeout
		else:
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	enemiesNum = get_tree().get_nodes_in_group("Enemy").size()
	numberOfEnemies.text = "Enemies: " + str(enemiesNum)
	
	if Global.player_health <= 0:
		Global.player_health = 0
		await get_tree().create_timer(0.5).timeout
		$DeathMenu/DeathMenu.show()
		MusicPlayer.play_menu_music()
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if get_tree().get_nodes_in_group("Enemy").size() == 0:
		if waveOver:
			$NextWaveTimer.start()
			waveOver = false


func _on_wave_timer_timeout():
	waveOver = true


func _on_spawn_timer_timeout():
	for i in range(spawnNum):
		if spawning:
			var spawnPos = possibleEnemyPoints.pick_random()
			var obj = enemy.instantiate()
			add_child(obj)
			obj.position = spawnPos.position
			await get_tree().create_timer(0.5).timeout
		else:
			pass
			
	if waveOver:
		spawning = false
	else:
		spawning = true
		$SpawnTimer.start(spawnTime)


func _on_next_wave_timer_timeout():
	if wave == 31:
		spawning = false
		waveOver = true
		currentWave.text = "November 1"
		await get_tree().create_timer(5).timeout
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://Scenes/credits.tscn")
	elif wave == 5:
		spawning = true
		wave += 1
		spawnNum += 1
		currentWave.text = "October " + str(wave)
		$SpawnTimer.start(spawnTime)
		$WaveTimer.start(waveTime)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		upgrades_menu.visible = true
		get_tree().paused = true
		
		await get_tree().create_timer(0.5, false).timeout

		var obj = shotgun.instantiate()
		var pos = $ShotgunSpawnPos.position
		add_child(obj)
		obj.position = pos
		$CanvasLayer/BossText.show()
		
	else:
		spawning = true
		wave += 1
		spawnNum += 1
		currentWave.text = "October " + str(wave)
		$SpawnTimer.start(spawnTime)
		$WaveTimer.start(waveTime)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		upgrades_menu.visible = true
		get_tree().paused = true

func _on_fall_area_body_entered(body):
	body.position = Vector3(0, 6, 45)

func _on_ammo_spawn_timer_timeout():
	if !waveOver:
		var spawnPos = possibleAmmoPoints.pick_random()
		var obj = ammo.instantiate()
		add_child(obj)
		obj.position = spawnPos.position
	ammoSpawnTime = randi_range(10, 25)
	$AmmoSpawnTimer.start(ammoSpawnTime)
