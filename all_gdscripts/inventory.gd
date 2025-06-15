extends Control

var gridContainer : GridContainer
var items : Array
var capacity := 20
var hoveredButton
var grabbedButton
var lastClickedMousePos : Vector2
var overTrash : bool

func _ready():
	gridContainer = $ScrollContainer/GridContainer
	populateButtons()
	pass
	
func _process(_delta):
	pass
func _input(_event):
	$MouseArea.position = get_tree().root.get_mouse_position()
	if hoveredButton != null:
		if Input.is_action_just_pressed("Drop An Item"):
			grabbedButton = hoveredButton
			lastClickedMousePos = get_tree().root.get_mouse_position()
		if lastClickedMousePos.distance_to(get_tree().root.get_mouse_position()) > 2:
			if Input.is_action_just_pressed("Drop An Item"):
				$MouseArea/InventoryButton.show()
				$MouseArea/InventoryButton.UpdateItem(grabbedButton.currentItem, 0)
			if Input.is_action_just_released("Drop An Item"):
				if overTrash:
					DeleteButton(grabbedButton)
				else:
					SwapButtons(grabbedButton, hoveredButton)
					$MouseArea/InventoryButton.hide()
					pass
	if Input.is_action_just_pressed("Drop An Item") && $MouseArea/InventoryButton.visible:
		$MouseArea/InventoryButton.hide()
		if overTrash:
			DeleteButton(grabbedButton)
		grabbedButton = null

func DeleteButton(button):
	items.remove_at(items.find(button.currentItem))
	reflowButtons()
	
func SwapButtons(button1, button2):
	var button1Index = button1.get_index()
	var button2Index = button2.get_index()
	gridContainer.move_child(button1, button2Index)
	gridContainer.move_child(button2, button1Index)
	
func populateButtons():
	for i in capacity:
		var packedScene = ResourceLoader.load("res://UI/inventory_button.tscn")
		var itemButton : Button = packedScene.instantiate()
		itemButton.connect("OnButtonClick", OnButtonClicked)
		$ScrollContainer/GridContainer.add_child(itemButton)
		
func Add(item : Resource):
	var currentItem = item.duplicate()
	for i in items.size():
		if items[i].ID == currentItem.ID && items[i].Quantity != items[i].StackSize:
			if items[i].Quantity + currentItem.Quantity > items[i].StackSize:
				items[i].Quantity = currentItem.StackSize
				currentItem.Quantity = -(currentItem.Quantity - items[i].StackSize)
				UpdateButton(i)
			else:
				items[i].Quantity += currentItem.Quantity
				currentItem.Quantity = 0
				UpdateButton(i)
				
	if item.Quantity > 0:
		if item.Quantity < item.StackSize:
			items.append(item)
			UpdateButton(items.size() - 1)
		else:
			var tempItem = currentItem.duplicate()
			tempItem.Quantity = currentItem.StackSize
			items.append(tempItem)
			UpdateButton(items.size() - 1)
			currentItem.Quantity -= currentItem.StackSize
			Add(currentItem)

func Remove(item : Resource):
	var currentItem = item
	for i in items.size():
		if items[i].ID == currentItem.ID:
			if items[i].Quantity - currentItem.Quantity < 0:
				currentItem.Quantity -= items[i].Quantity
				items[i].Quantity = 0
				UpdateButton(i)
			else:
				items[i].Quantity -= currentItem.Quantity
				currentItem.Quantity = 0
				UpdateButton(i)
				
		if currentItem.Quantity <= 0:
			break
	var _tempItems = items.duplicate()
	var offset = 0
	#for i in items.size():
		#if items[i - offset].Quantity == 0:
			#items.remove_at(i)
			#offset -= 1
	for i in items.size():
		var index_to_check = i - offset
		if index_to_check >= 0 and index_to_check < items.size():
			if items[index_to_check].Quantity == 0:
				items.remove_at(i)
				offset -= 1
		else:
			print("Invalid index: ", index_to_check)

		reflowButtons()
	
func reflowButtons():
	for i in capacity:
		UpdateButton(i)
		
	
func UpdateButton(index : int):
	if range(items.size()).has(index):
		gridContainer.get_child(index).UpdateItem(items[index], index)
	else:
		gridContainer.get_child(index).UpdateItem(null, index)
	

func OnButtonClicked(_index, currentItem):
	#print("CLICKED")
	if currentItem != null:
		currentItem.UseItem()


func _on_button_button_down() -> void:
	Add(ResourceLoader.load("res://TestItem.tres"))


func _on_button_2_button_down() -> void:
	Remove(ResourceLoader.load("res://TestItem.tres"))


func _on_mouse_area_area_entered(area: Area2D) -> void:
	hoveredButton = area.get_parent()
	pass # Replace with function body.


func _on_mouse_area_area_exited(_area: Area2D) -> void:
	hoveredButton = null
	pass # Replace with function body.


func _on_trash_area_area_entered(_area: Area2D) -> void:
	overTrash = true
	pass # Replace with function body.


func _on_trash_area_area_exited(_area: Area2D) -> void:
	overTrash = false
	pass # Replace with function body.


func _on_button_4_button_down() -> void:
	Add(ResourceLoader.load("res://TestItem2.tres"))
	pass # Replace with function body.


func _on_button_5_button_down() -> void:
	Remove(ResourceLoader.load("res://TestItem2.tres"))
	pass # Replace with function body.
