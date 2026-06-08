extends Control

@onready var day_label: Label = $CenterContainer/DayLabel
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# Atualiza o texto dinamicamente perguntando ao GameManager
	day_label.text = "DIA " + str(GameManager.current_day)
	
	# Garante que a Label comece invisível antes da animação rodar
	day_label.modulate.a = 0
	
	# Conecta o sinal de quando a animação terminar para pularmos de cena
	anim_player.animation_finished.connect(_on_animation_finished)
	
	# Inicia a animação de Fade
	anim_player.play("fade")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "fade":
		# MUDANÇA AQUI: Verifica em qual dia estamos para decidir o destino
		if GameManager.current_day == 1:
			# Se for o primeiro dia, passa pela introdução da história
			get_tree().change_scene_to_file("res://gameplay/lore/intro_lore.tscn")
		else:
			# Se for Dia 2 ou mais, pula a introdução e vai direto para a mesa com o PC!
			get_tree().change_scene_to_file("res://gameplay/pc/pc_main.tscn")
