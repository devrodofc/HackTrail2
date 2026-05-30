extends Control

@onready var back_button: Button = $MarginContainer/VBoxContainer/FreeMove/BackButton

func _ready() -> void:
	# Foca no botão para navegação por teclado/controle
	back_button.grab_focus()
	
	back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	# Retorna para o Menu de Opções
	get_tree().change_scene_to_file("res://ui/menus/options/options.tscn")
