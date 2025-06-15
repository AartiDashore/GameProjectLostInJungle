extends Button

var currentItem
var currentIcon
var currentLabel
var index

signal OnButtonClick(Index, item)

func UpdateItem(item, _index):
	self.index = index
	currentItem = item
	
	if currentItem == null:
		currentIcon.texture = null
		currentLabel.text = ""
	else:
		currentIcon.texture = item.Icon
		currentLabel.text = str(item.Quantity)

func _on_area_2d_area_entered(_area: Area2D) -> void:
	currentIcon = $TextureRect
	currentLabel = $Label

func _on_area_2d_area_exited(_area: Area2D) -> void:
	pass # Replace with function body.


func _on_button_down() -> void:
	emit_signal("OnButtonClick", index, currentItem)
	pass # Replace with function body.
