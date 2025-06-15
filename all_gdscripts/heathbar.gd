extends CanvasLayer

const MAX_HEALTH = 10
var health = MAX_HEALTH

func _ready() -> void:
	update_health_ui()
	$Health.max_value = MAX_HEALTH
	
	
func set_health_label() -> void:
	$HealthLabel.text = "Health: %s" % health
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		damage()

func set_health_bar() -> void:
	$Health.value = health

func update_health_ui():
	set_health_bar()
	set_health_label()
	
			
func damage() -> void:
	health -= 1
	if health < 0:
		health = MAX_HEALTH
	update_health_ui()
