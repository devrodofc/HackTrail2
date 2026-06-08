extends Control

# Botões dos personagens (Arraste os TextureButtons no Inspector)
@export var lusquinha_btn: TextureButton
@export var nathan_btn: TextureButton
@export var leozin_btn: TextureButton

# Elementos da UI de Resultado (Arraste uma Label e um Botão de reiniciar)
@export var result_container: Control
@export var result_label: Label
@export var restart_btn: BaseButton

# Configurações de tamanho e opacidade
var scale_active := Vector2(0.72, 0.72) # Aumenta levemente ao passar o mouse
var scale_normal := Vector2(0.7, 0.7)
var alpha_active := 1.0
var alpha_inactive := 0.4

var choice_enabled := false
var active_tweens := {} # Guarda as animações de cada personagem separadamente

func _ready() -> void:
	# Oculta o resultado e o botão de reiniciar no começo
	if result_container:
		result_container.hide()
		
	# Estado inicial apagado para os três
	_set_initial_state(lusquinha_btn)
	_set_initial_state(nathan_btn)
	_set_initial_state(leozin_btn)
	
	# Conexões de Sinais dos Personagens (Mouse Entrar, Sair e Clicar)
	_connect_button_signals(lusquinha_btn, "Lusquinha", false)
	_connect_button_signals(nathan_btn, "Nathan", true) # Nathan é o correto
	_connect_button_signals(leozin_btn, "Leozin", false)
	
	# Conexão do botão de reiniciar
	if restart_btn:
		restart_btn.pressed.connect(_on_restart_pressed)
		
	# Conecta o sinal para liberar o jogo quando o diálogo acabar
	EventBus.dialogue_finished.connect(_on_intro_dialogue_finished)
	
	# Dispara o diálogo do Professor Ronisson
	await get_tree().create_timer(1.0).timeout
	EventBus.dialogue_requested.emit("choice_intro")

func _set_initial_state(btn: TextureButton) -> void:
	if btn:
		btn.pivot_offset = btn.size / 2 # Garante que ele aumente a partir do centro
		btn.scale = scale_normal
		btn.modulate.a = alpha_inactive

func _connect_button_signals(btn: TextureButton, char_name: String, is_correct: bool) -> void:
	if not btn: return
	btn.mouse_entered.connect(func(): _on_mouse_entered_char(btn))
	btn.mouse_exited.connect(func(): _on_mouse_exited_char(btn))
	btn.pressed.connect(func(): _on_char_selected(char_name, is_correct))

# --- BLOQUEIO NARRATIVO ---
func _on_intro_dialogue_finished() -> void:
	if EventBus.dialogue_finished.is_connected(_on_intro_dialogue_finished):
		EventBus.dialogue_finished.disconnect(_on_intro_dialogue_finished)
	
	print("[ESCOLHA] Diálogo do professor terminou. Escolha liberada!")
	choice_enabled = true

# --- EFEITOS DE HOVER (MOUSE PASSAR POR CIMA) ---
func _on_mouse_entered_char(btn: TextureButton) -> void:
	if not choice_enabled: return
	_animate_sprite(btn, scale_active, alpha_active)

func _on_mouse_exited_char(btn: TextureButton) -> void:
	if not choice_enabled: return
	_animate_sprite(btn, scale_normal, alpha_inactive)

func _animate_sprite(btn: TextureButton, target_scale: Vector2, target_alpha: float) -> void:
	if active_tweens.has(btn) and active_tweens[btn].is_running():
		active_tweens[btn].kill()
		
	var tween = create_tween().set_parallel(true)
	active_tweens[btn] = tween
	
	tween.tween_property(btn, "scale", target_scale, 0.2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(btn, "modulate:a", target_alpha, 0.2)

# --- SISTEMA DE JULGAMENTO (CLIQUE) ---
func _on_char_selected(char_name: String, is_correct: bool) -> void:
	if not choice_enabled: return
	
	# Trava a escolha para o jogador não clicar em múltiplos botões
	choice_enabled = false 
	print("[ESCOLHA] Jogador escolheu: ", char_name)
	
	if is_correct:
		result_label.text = "Você escolheu corretamente, Nathan foi preso e pagará por seus crimes. Você ganhou!"
	else:
		result_label.text = "Você errou! O hacker ainda está à solta e destruiu os sistemas da Unifor. Tente novamente."
		
	# Mostra o painel com o veredito e o botão de reiniciar
	if result_container:
		result_container.show()

# --- REINICIAR O JOGO ---
func _on_restart_pressed() -> void:
	print("[ESCOLHA] Reiniciando jogo... Voltando para o menu principal.")
	
	# Reseta os dados do GameManager para o Dia 1
	GameManager.current_day = 1
	GameManager.hacked_tasks_to_fix.clear()
	
	# Força o banco de dados de códigos a reembaralhar as cartas do zero
	if CodeDB:
		CodeDB.reset_and_shuffle_decks()
		
	# Muda para a sua cena inicial do menu ("cena de play")
	# ATENÇÃO: Troque pelo caminho exato da sua cena de Menu/Play principal!
	get_tree().change_scene_to_file("res://ui/menus/main/main.tscn")
