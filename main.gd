extends Node3D

@export var enemy_scene: PackedScene;

func _on_enemy_timer_timeout():
	var enemy = enemy_scene.instantiate();
	
	var enemy_spawn_location = get_node("SpawnPath/SpawnLocation");
	enemy_spawn_location.progress_ratio = randf();
	
	var player_position = $Player.global_position;
	
	enemy.initialize(enemy_spawn_location.global_position,player_position)
	
	add_child(enemy);
	
	enemy.squashed.connect($UserInterface/ScoreLabel._on_enemy_squashed.bind())


func _on_player_hit():
	$EnemyTimer.stop()
	$UserInterface/Retry.show()
	
func _ready():
	$UserInterface/Retry.hide()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()	
