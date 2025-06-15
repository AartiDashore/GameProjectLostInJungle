extends Node3D
class_name GameManager

#@onready var inventory = preload("res://all_gdscripts/InventoryManager.gd").new()
#@onready var enemy_manager = preload("res://all_gdscripts/EnemyManager.gd").new()
#@onready var puzzle_manager = preload("res://all_gdscripts/PuzzleManager.gd").new()
@onready var sound_manager = preload("res://all_gdscripts/SoundFacade.gd").new()

## === Inventory Management ===
#func add_item(item_name: String, quantity: int):
	#inventory.add_item(item_name, quantity)
#
#func remove_item(item_name: String, quantity: int):
	#inventory.remove_item(item_name, quantity)
#
## === Enemy Interaction ===
#func trigger_enemy_action(enemy_id: int, action: String):
	#enemy_manager.perform_action(enemy_id, action)
#
## === Puzzle Solving ===
#func solve_puzzle(puzzle_id: int, solution: String):
	#puzzle_manager.check_solution(puzzle_id, solution)

# === Sound Management ===
func play_sound(sound_name: String):
	sound_manager.play_ambient(sound_name)
	sound_manager.play_footstep(sound_name)
	
# === Timer & Pause State ===
@onready var game_timer = $GameTimer
@onready var pause_menu = $PauseMenu

var play_time := 0
var is_game_paused := false

func _ready():
	# Start the gameplay timer
	game_timer.timeout.connect(_on_GameTimer_timeout)
	game_timer.start()
	
	# Add sound_manager to the scene tree if needed
	add_child(sound_manager)

func _on_GameTimer_timeout():
	if !is_game_paused:
		play_time += 1

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC key
		toggle_pause()

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC key by default
		toggle_pause()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()		

func toggle_pause():
	is_game_paused = !is_game_paused
	get_tree().paused = is_game_paused
	pause_menu.visible = is_game_paused
	if is_game_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # or MOUSE_MODE_HIDDEN depending on your game

func resume_game():
	is_game_paused = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pause_menu.visible = false

# === Handling Mouse visibility while toggling menu =====
func set_mouse_mode(is_paused: bool):
	if is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
