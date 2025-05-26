extends Node
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
	
