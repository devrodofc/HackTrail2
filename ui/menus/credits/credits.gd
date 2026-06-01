extends Control

@onready var back_button: Button = $MarginContainer/VBoxContainer/FreeMove/BackButton

var pulse_time := 0.0
var button_selected := false

func _ready() -> void:
	await get_tree().process_frame
	
	_setup_back_button()
	
	# Foca no botão para navegação por teclado/controle
	back_button.grab_focus()
	_select_back_button()
	
	back_button.pressed.connect(_on_back_pressed)

func _process(delta: float) -> void:
	if not button_selected:
		return
	
	pulse_time += delta
	
	var pulse = 1.08 + sin(pulse_time * 4.0) * 0.025
	back_button.scale = Vector2(pulse, pulse)
	
	if sin(pulse_time * 18.0) > 0.96:
		back_button.modulate = Color("#FF2BD6")
	else:
		back_button.modulate = Color("#00C8E8")

func _setup_back_button() -> void:
	back_button.pivot_offset = back_button.size / 2
	
	back_button.mouse_entered.connect(func():
		_select_back_button()
	)
	
	back_button.focus_entered.connect(func():
		_select_back_button()
	)

func _select_back_button() -> void:
	button_selected = true
	pulse_time = 0.0
	back_button.scale = Vector2(1.08, 1.08)
	back_button.modulate = Color("#00C8E8")

func _on_back_pressed() -> void:
	# Retorna para o Menu de Opções
	get_tree().change_scene_to_file("res://ui/menus/options/options.tscn")
