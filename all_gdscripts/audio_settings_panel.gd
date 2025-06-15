extends Panel

@onready var background_slider = $BackgroundSlider
@onready var footstep_slider = $FootstepSlider
@onready var mute_toggle = $BackgroundMuteCheck
@onready var main_menu = get_parent().get_node("/root/Main/PauseMenu/Panel")

func _ready():
	load_audio_settings()

	background_slider.value_changed.connect(_on_background_volume_changed)
	footstep_slider.value_changed.connect(_on_footstep_volume_changed)
	mute_toggle.toggled.connect(_on_mute_toggled)

func _on_background_volume_changed(value):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Background"), db)
	save_audio_settings()

func _on_footstep_volume_changed(value):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Footsteps"), db)
	save_audio_settings()

func _on_mute_toggled(pressed):
	var buses = ["Background", "Footsteps"]
	for bus in buses:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), pressed)
	save_audio_settings()

func save_audio_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "background_volume", background_slider.value)
	config.set_value("audio", "footstep_volume", footstep_slider.value)
	config.set_value("audio", "mute", mute_toggle.button_pressed)
	config.save("user://settings.cfg")

func load_audio_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") != OK:
		return

	background_slider.value = config.get_value("audio", "background_volume", 1.0)
	footstep_slider.value = config.get_value("audio", "footstep_volume", 1.0)
	mute_toggle.button_pressed = config.get_value("audio", "mute", false)

	# Apply loaded values
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Background"), linear_to_db(background_slider.value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Footsteps"), linear_to_db(footstep_slider.value))
	for bus in ["Background", "Footsteps"]:
		AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), mute_toggle.button_pressed)

# Converts slider [0.0–1.0] to decibels
func linear_to_db(value):
	if value <= 0.0:
		return -80  # effectively silent
	return 20.0 * (log(value) / log(10))


func _on_button_back_pressed() -> void:
	self.visible = false
	main_menu.visible = true
