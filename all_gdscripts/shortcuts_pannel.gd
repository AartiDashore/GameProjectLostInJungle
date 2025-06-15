extends Panel

@onready var main_menu = get_node("../Panel")
@onready var shortcuts_list = get_node("/root/Main/PauseMenu/ShortcutsPanel/ScrollContainer/VBoxContainer")

func _ready() -> void:
	var shortcuts = {
		"Open Menu": "Esc",
		"Move Forward": "W / Up Arrow",
		"Move Backward": "S / Down Arrow",
		"Left": "A / Left Arrow",
		"Right": "D / Right Arrow",
		"Jump": "Space",
		"Sprint": "Shift + W / Shift + Up Arrow",
		"Pick Up Item": "E",
		"Drop An Item": "Q",
		"Inventory": "R",
		"Attack": "X"
	}

	# Clear previous labels if this gets called more than once
	for child in shortcuts_list.get_children():
		child.queue_free()

	for action in shortcuts.keys():
		var label = Label.new()
		label.text = "%s: %s" % [action, shortcuts[action]]
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER  # Center text
		shortcuts_list.add_child(label)


func _on_button_back_pressed() -> void:
	self.visible = false
	main_menu.visible = true
