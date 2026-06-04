extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/Spacer/VBoxContainer/PlayButton
@onready var options_button: Button = $MarginContainer/VBoxContainer/Spacer/VBoxContainer/OptionsButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/Spacer/VBoxContainer/QuitButton

var selected_button: Button = null
var pulse_time := 0.0

func _ready() -> void:
	# Espera o layout dos containers terminar antes de calcular o centro dos botões
	await get_tree().process_frame
	
	_setup_button(play_button)
	_setup_button(options_button)
	_setup_button(quit_button)
	
	# Foca no botão Jogar automaticamente para quem joga no teclado
	play_button.grab_focus()
	_select_button(play_button)
	
	# Conectando os sinais dos botões via código
	play_button.pressed.connect(_on_play_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _process(delta: float) -> void:
	pulse_time += delta
	
	if selected_button == null:
		return
	
	var pulse = 1.08 + sin(pulse_time * 4.0) * 0.025
	selected_button.scale = Vector2(pulse, pulse)
	
	if sin(pulse_time * 18.0) > 0.96:
		selected_button.modulate = Color("#FF2BD6")
	else:
		selected_button.modulate = Color("#00C8E8")

func _setup_button(button: Button) -> void:
	button.pivot_offset = button.size / 2
	
	button.mouse_entered.connect(func():
		_select_button(button)
	)
	
	button.mouse_exited.connect(func():
		if button != selected_button:
			_reset_button(button)
	)
	
	button.focus_entered.connect(func():
		_select_button(button)
	)

func _select_button(button: Button) -> void:
	if selected_button != null and selected_button != button:
		_reset_button(selected_button)
	
	selected_button = button
	selected_button.scale = Vector2(1.08, 1.08)
	selected_button.modulate = Color("#00C8E8")
	pulse_time = 0.0

func _reset_button(button: Button) -> void:
	button.scale = Vector2.ONE
	button.modulate = Color("#F2F4F8")

func _on_play_button_pressed() -> void:
	GameManager.start_game() 
	get_tree().change_scene_to_file("res://ui/transitions/day_transition.tscn")

func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/menus/options/options.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
