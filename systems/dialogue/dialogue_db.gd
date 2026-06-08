class_name DialogueDB
extends Node

# Estrutura: "ID_DO_DIALOGO": [ { "name": "Quem fala", "text": "O que fala" }, ... ]
const DATA: Dictionary = {
	"intro_lore": [
		{
			"name": "Prof. Ronisson",
			"text": "Bem-vindo ao laboratório de programação da Unifor. Hoje o dia será longo..."
		},
		{
			"name": "Player",
			"text": "Estou pronto, professor. Qual é o problema de hoje?"
		},
		{
			"name": "Prof. Ronisson",
			"text": "Algum engraçadinho invadiu o sistema ontem. Preciso que Player analise o código dos alunos."
		},
		{
			"name": "Player",
			"text": "Pode deixar. Vou separar o que é erro comum do que é ataque cibernético."
		},
		{
			"name": "Prof. Ronisson",
			"text": "Fique atento a códigos maliciosos ou comportamentos estranhos. Não temos muito tempo!"
		}
	],
	"tutorial_pc": [
		{
			"name": "Prof. Ronisson",
			"text": "Bem vindo à sala de aula, aqui lhe ensinarei a analisar os códigos dos alunos"
		}
	],
	"time_out_pc": [
		{
			"name": "Professor Ronisson",
			"text": "BIP... BIP... Bloqueio de segurança ativado! Seu tempo de expediente no terminal esgotou."
		},
		{
			"name": "Professor Ronisson",
			"text": "Precisamos ir para a próxima fase da investigação. Saia do computador e venha falar comigo na sala de interrogatórios imediatamente."
		}
	],
	"day_finished_pc": [
		{
			"name": "Professor Ronisson",
			"text": "Excelente trabalho analisando os dados dos alunos, sua cota do dia foi batida com sucesso."
		},
		{
			"name": "Professor Ronisson",
			"text": "O terminal foi encriptado. Vamos para a próxima fase. É hora de descobrir quem plantou esses códigos maliciosos."
		}
	],
	"tutorial_hacker_fix": [
		{
		"name": "Sistema",
		"text": "AVISO: Anomalias detectadas em códigos previamente isolados."
		},
		{
		"name": "Sistema",
		"text": "Iniciando protocolo de mitigação. Reescreva os fragmentos corrompidos para restaurar a integridade do sistema."
		}
	],
	"hacker_phase_success": [
		{
		"name": "Sistema",
		"text": "Protocolo de mitigação concluído. Todas as ameaças foram neutralizadas."
		},
		{
		"name": "Sistema",
		"text": "Desconectando terminal..."
		}
	],
	"hacker_time_out": [
		{
		"name": "Sistema",
		"text": "FALHA CRÍTICA: Tempo esgotado. Ameaça se espalhou pelo sistema."
		},
		{
		"name": "Sistema",
		"text": "Bloqueando acesso imediatamente."
		}
	],
	"interrogation_day1": [
		{
			"name": "Você",
			"text": "Senta aí, Lusquinha. A gente precisa conversar sobre o que aconteceu no laboratório."
		},
		{
			"name": "Lusquinha",
			"text": "Cara, eu não fiz nada! Eu juro! Eu só tava jogando no meu PC lá no fundo."
		},
		{
			"name": "Você",
			"text": "Os registros do servidor dizem outra coisa. Seu IP tava floodando a rede."
		},
		{
			"name": "Lusquinha",
			"text": "Pô, meu PC tava travando muito, eu devo ter baixado algum mod esquisito praquele jogo de tiro... Eu não sou hacker!"
		},
		{
			"name": "Você",
			"text": "Vou analisar os logs da sua máquina. Se você estiver mentindo, o Prof. Ronisson vai saber."
		}
	],
	"conclusion_lusquinha": [
		{
			"name": "Você",
			"text": "Analisei seus logs, Lusquinha. De ponta a ponta."
		},
		{
			"name": "Lusquinha",
			"text": "E aí? Você viu que eu não menti, né? Eu sou inocente!"
		},
		{
			"name": "Você",
			"text": "Sim. Era apenas um malware escondido em um mod de jogo que você baixou. Ele estava usando seu PC como zumbi."
		},
		{
			"name": "Lusquinha",
			"text": "Ufa! Que alívio... Vou deletar tudo agora mesmo! Valeu por me ajudar, cara."
		},
		{
			"name": "Você",
			"text": "Só tome mais cuidado. O culpado ainda está lá fora e agora ele sabe que estamos de olho."
		},
	],
	"interrogation_day2": [
		{
			"name": "Você",
			"text": "Senta aí, Nathan. Precisamos conversar sobre o tráfego do seu terminal hoje."
		},
		{
			"name": "Nathan",
			"text": "Conversar sobre o quê? Meu código rodou perfeitamente. Se o servidor caiu, não foi culpa minha."
		},
		{
			"name": "Você",
			"text": "O problema não é o servidor cair. Os logs mostram varreduras de portas e tentativas de injeção vindo da sua máquina."
		},
		{
			"name": "Nathan",
			"text": "Ah, isso? Eu estava fazendo um 'pentest' proativo. Alguém tem que garantir a segurança desse laboratório."
		},
		{
			"name": "Você",
			"text": "Auditoria não autorizada é infração grave. Vou fazer uma varredura completa na sua máquina antes de relatar ao professor."
		}
	],
	"conclusion_nathan": [
		{
			"name": "Você",
			"text": "Terminei de analisar sua máquina, Nathan."
		},
		{
			"name": "Nathan",
			"text": "E aí? Provou que eu sou o único aluno blindando a rede da universidade?"
		},
		{
			"name": "Você",
			"text": "Pelo contrário. A sua brincadeira de 'pentest' abriu um backdoor. O verdadeiro invasor usou a sua máquina como ponte."
		},
		{
			"name": "Nathan",
			"text": "O quê?! Mas eu fechei todas as portas... Droga. Fui usado de laranja."
		},
		{
			"name": "Você",
			"text": "Exato. O professor vai te dar uma advertência formal. E o verdadeiro hacker continua solto."
		},
	],
	"interrogation_day3": [
		{
			"name": "Você",
			"text": "Leozin, precisamos falar sobre os pacotes suspeitos saindo do seu ambiente de desenvolvimento."
		},
		{
			"name": "Leozin",
			"text": "Do meu? Cara, eu só rodo script otimizado. Meu ambiente é impecável, zero bugs."
		},
		{
			"name": "Você",
			"text": "Então como você explica o minerador de criptomoedas e o script de exfiltração rodando em background no seu terminal?"
		},
		{
			"name": "Leozin",
			"text": "Pera... eu baixei uma biblioteca paralela ontem que prometia compilar o código 10x mais rápido. Tava cheia de estrelas no fórum!"
		},
		{
			"name": "Você",
			"text": "Você rodou código de terceiros sem auditar na rede do laboratório? Vou ter que isolar sua máquina agora mesmo."
		}
	],
	"conclusion_leozin": [
		{
			"name": "Você",
			"text": "A análise terminou, Leozin."
		},
		{
			"name": "Leozin",
			"text": "E aí? Conseguiu limpar aquela biblioteca esquisita do meu terminal?"
		},
		{
			"name": "Você",
			"text": "Remover o minerador foi fácil. O problema é que a biblioteca era um Cavalo de Troia. Ela abriu as portas da rede principal."
		},
		{
			"name": "Leozin",
			"text": "Puts... o Professor Ronisson vai acabar com a minha nota. Fui tapeado por um repositório falso."
		},
		{
			"name": "Você",
			"text": "A nota é o de menos agora. O hacker conseguiu acesso de administrador usando a sua máquina. A situação saiu do controle."
		}
	],
	"choice_intro": [
		{
			"name": "Prof. Ronisson",
			"text": "A situação saiu completamente do controle! Analisamos todos os logs e os três suspeitos estão na sala. Quem é o verdadeiro hacker?"
		}
	]
}

static func get_dialogue(id: String) -> Array:
	if DATA.has(id):
		return DATA[id]
	push_error("Diálogo não encontrado no banco de dados: " + id)
	return []
