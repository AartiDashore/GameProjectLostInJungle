extends Control

@onready var timer_label = get_node("/root/Main/PauseMenu/TopLabelPanel/Label_Timer")
@onready var shortcuts_panel = get_node("/root/Main/PauseMenu/ShortcutsPanel")
# ==== Saving The Audio Settings from Menu And See it Getting Applied (Continued Below)========
@onready var audio_panel = get_node("/root/Main/PauseMenu/AudioSettingsPanel")
@onready var background_slider = get_node("/root/Main/PauseMenu/AudioSettingsPanel/BackgroundSlider")
@onready var background_mute_check = get_node("/root/Main/PauseMenu/AudioSettingsPanel/BackgroundMuteCheck")
@onready var footsteps_slider = get_node("/root/Main/PauseMenu/AudioSettingsPanel/FootstepSlider")
@onready var footsteps_mute_check = get_node("/root/Main/PauseMenu/AudioSettingsPanel/FootstepsMuteCheck")
@onready var main_panel = get_node("/root/Main/PauseMenu/Panel")  # To return back to main menu options
@onready var top_label = get_node("/root/Main/PauseMenu/TopLabelPanel")

# === Utility ===
func linear_to_db(value: float) -> float:
	if value <= 0.0:
		return -80.0
	return 20.0 * log(value) / log(10)

# === Save / Load Audio Settings ===
func save_audio_settings() -> void:
	if background_slider == null or footsteps_slider == null:
		push_warning("Sliders not ready.")
		return


	var config = ConfigFile.new()
	config.set_value("audio", "background_volume", background_slider.value)
	config.set_value("audio", "background_mute", background_mute_check.button_pressed)
	config.set_value("audio", "footsteps_volume", footsteps_slider.value)
	config.set_value("audio", "footsteps_mute", footsteps_mute_check.button_pressed)
	config.save("user://audio_settings.cfg")

func load_audio_settings() -> void:
	var config = ConfigFile.new()
	if config.load("user://audio_settings.cfg") == OK:
		background_slider.value = config.get_value("audio", "background_volume", 1.0)
		background_mute_check.button_pressed = config.get_value("audio", "background_mute", false)
		footsteps_slider.value = config.get_value("audio", "footsteps_volume", 1.0)
		footsteps_mute_check.button_pressed = config.get_value("audio", "footsteps_mute", false)

func _ready():
	await get_tree().process_frame  # Ensures all nodes are initialized before anything else

	shortcuts_panel.visible = false
	load_audio_settings()

	audio_panel.visible = false  # 🔹 Ensure audio panel is hidden at start
	main_panel.visible = true    # 🔹 Show main panel (default pause menu)

	# Now safe to connect
	if not background_mute_check.toggled.is_connected(_on_background_mute_toggled):
		background_mute_check.toggled.connect(_on_background_mute_toggled)
	if not footsteps_slider.value_changed.is_connected(_on_footstep_volume_slider_value_changed):
		footsteps_slider.value_changed.connect(_on_footstep_volume_slider_value_changed)
	if not footsteps_mute_check.toggled.is_connected(_on_footsteps_mute_toggled):
		footsteps_mute_check.toggled.connect(_on_footsteps_mute_toggled)

	_on_background_volume_slider_value_changed(background_slider.value)
	_on_footstep_volume_slider_value_changed(footsteps_slider.value)

func _process(_delta):
	if visible:
		var game_manager = get_node("/root/Main")  # adjust path to match actual node name
		var play_time = game_manager.play_time
		
		var hours = play_time / 3600
		var minutes = game_manager.play_time / 60
		var seconds = game_manager.play_time % 60
		timer_label.text = "Time Elapsed: %02d:%02d:%02d" % [hours,minutes, seconds]
	

func _on_button_continue_pressed() -> void:
	var gm = get_node("/root/Main")
	gm.resume_game()

func _on_button_new_game_pressed() -> void:
	var gm = get_node("/root/Main")
	gm.resume_game()
	get_tree().reload_current_scene()

func _on_button_quit_pressed() -> void:
	get_tree().quit()
	
func _on_button_keyboard_shortcuts_pressed():
	shortcuts_panel.visible = true
	main_panel.visible = false

func _on_button_close_menu_pressed() -> void:
	#save_settings()
	close_menu()
	get_node("/root/Main").resume_game()

func close_menu():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Hide cursor
	visible = false  # Hide the PauseMenu

# ==== Audio Settings ====
func _on_button_audio_settings_pressed() -> void:
	top_label.visible = true
	main_panel.visible = false
	audio_panel.visible = true

func _on_background_volume_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Background"), db)
	save_audio_settings()

func _on_footstep_volume_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Footsteps"), db)
	save_audio_settings()

# ==== Saving The Audio Settings from Menu And See it Getting Applied (Continued)========

func _on_background_mute_toggled(button_pressed: bool) -> void:
	var bus_index = AudioServer.get_bus_index("Background")
	AudioServer.set_bus_mute(bus_index, button_pressed)
	save_audio_settings()

func _on_footsteps_mute_toggled(button_pressed: bool) -> void:
	var bus_index = AudioServer.get_bus_index("Footsteps")
	AudioServer.set_bus_mute(bus_index, button_pressed)
	save_audio_settings()

func _on_button_back_to_main_menu_pressed():
	shortcuts_panel.visible = false
	audio_panel.visible = false
	main_panel.visible = true
