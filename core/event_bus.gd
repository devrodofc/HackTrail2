extends Node

# ==========================================
# Sinais Globais de "Hacktrail"
# ==========================================

# Controle de Fluxo do Jogo
signal game_started
signal day_started(day_number: int)
signal day_ended(passed: bool)

# Minigames
signal code_analysis_completed(approved: bool)
signal hack_prevented(success: bool)

# UI e Diálogos
signal dialogue_requested(dialogue_id: String)
