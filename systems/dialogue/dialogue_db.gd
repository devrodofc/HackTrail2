class_name DialogueDB
extends Node

const DATA: Dictionary = {
	"intro_lore": [
		{
			"name": "Prof. Ronisson",
			"text": "Bem-vindo ao laboratório de programação da Unifor. Hoje vai ser um dia longo..."
		},
		{
			"name": "Player",
			"text": "Estou pronto, professor. Qual é o problema de hoje?"
		},
		{
			"name": "Prof. Ronisson",
			"text": "Algum engraçadinho invadiu o sistema ontem à noite. Preciso que você analise o código dos alunos e me diga se tem algo fora do lugar."
		},
		{
			"name": "Player",
			"text": "Entendido. Vou separar o que é erro de novato do que é ataque de verdade."
		},
		{
			"name": "Prof. Ronisson",
			"text": "Fique atento a qualquer anomalia — backdoors, código malicioso, tráfego de rede suspeito. E corra, não temos tempo a perder."
		}
	],
	"nathan_intro": [
		{
			"name": "Nathan",
			"text": "Ei! Você deve ser o novo assistente do Ronisson, né? Sou o... DynasM— Nathan. Me chama de Nathan."
		},
		{
			"name": "Player",
			"text": "DynasM? Que foi isso?"
		},
		{
			"name": "Nathan",
			"text": "Haha, nada não. Me confundi com meu nick de jogo online. Péssimo hábito. E aí, veio fuçar nos terminais?"
		},
		{
			"name": "Player",
			"text": "Mais ou menos. Vou analisar os códigos do laboratório — alguém invadiu o sistema ontem."
		},
		{
			"name": "Nathan",
			"text": "Sério? Que... interessante. Olha, se precisar de ajuda com segurança de rede, é só falar. Entendo bastante do assunto."
		}
	],
	"tutorial_pc": [
		{
			"name": "Prof. Ronisson",
			"text": "Esse é o terminal de análise. Aqui você vai revisar os códigos dos alunos e identificar qualquer coisa suspeita. Comece pela fila e me avise se achar algo."
		},
		{
			"name": "Prof. Ronisson",
			"text": "Clique no botão com V para aprovar o código, no X para reprovar e no botão com aviso para reportar um código caso haja algo suspeito."
		},
		{
			"name": "Prof. Ronisson",
			"text": "Clique no botão de power para iniciar o computador"
		}
	],
	"time_out_pc": [
		{
			"name": "Prof. Ronisson",
			"text": "BIP... BIP... Bloqueio de segurança ativado! Seu tempo de acesso ao terminal esgotou."
		},
		{
			"name": "Prof. Ronisson",
			"text": "Preciso de você na sala de interrogatórios agora. Vá até lá imediatamente."
		}
	],
	"day_finished_pc": [
		{
			"name": "Prof. Ronisson",
			"text": "Bom trabalho. Você bateu a cota do dia nos terminais."
		},
		{
			"name": "Prof. Ronisson",
			"text": "Acesso encerrado. Agora é hora de interrogar os suspeitos e descobrir quem está por trás de tudo isso."
		}
	],
	"tutorial_hacker_fix": [
		{
			"name": "Sistema",
			"text": "Prof. Ronisson: Foram identificados códigos de maliciosos, corrija antes que o tempo acabe!"
		},
	],
	"hacker_phase_success": [
		{
			"name": "Prof. Ronisson",
			"text": "Todos os códigos maliciosos corrigidos, aguarde o próximo dia para avaliar novamente os códigos."
		},
		{
			"name": "Sistema",
			"text": "Encerrando sessão do terminal..."
		}
	],
	"hacker_time_out": [
		{
			"name": "Sistema",
			"text": "FALHA CRÍTICA: Tempo esgotado. A ameaça se propagou pelo sistema."
		},
		{
			"name": "Sistema",
			"text": "Acesso bloqueado. Reiniciando protocolo de segurança."
		}
	],
	"interrogation_day1": [
		{
			"name": "Você",
			"text": "Senta aí, Lusquinha. A gente precisa conversar sobre o que rolou no laboratório."
		},
		{
			"name": "Lusquinha",
			"text": "Cara, eu não fiz nada! Juro! Eu tava só jogando lá no fundo, no meu canto."
		},
		{
			"name": "Você",
			"text": "Os registros do servidor dizem outra coisa. Seu IP tava floodando a rede inteira."
		},
		{
			"name": "Lusquinha",
			"text": "Pô, meu PC travou muito nesse dia... Devo ter baixado algum mod esquisito pro jogo de tiro. Mas eu juro que não sou hacker, nem sei fazer isso!"
		},
		{
			"name": "Você",
			"text": "Vou analisar os logs da sua máquina. Se estiver mentindo, o Prof. Ronisson vai saber antes de você chegar em casa."
		}
	],
	"conclusion_lusquinha": [
		{
			"name": "Você",
			"text": "Terminei de analisar seus logs, Lusquinha. Do início ao fim."
		},
		{
			"name": "Lusquinha",
			"text": "E aí? Você viu que eu não menti, né? Sou inocente!"
		},
		{
			"name": "Você",
			"text": "Sim. Era um malware escondido num mod de jogo que você baixou. Ele transformou seu PC num zumbi sem você perceber."
		},
		{
			"name": "Lusquinha",
			"text": "Ufa! Que alívio... Vou deletar tudo agora mesmo. Valeu por não me ferrar, cara."
		},
		{
			"name": "Você",
			"text": "Só toma mais cuidado. O verdadeiro culpado ainda está solto — e agora ele sabe que estamos investigando."
		}
	],
	"conclusion_nathan": [
		{
			"name": "Você",
			"text": "Terminei a análise, Nathan."
		},
		{
			"name": "Nathan",
			"text": "Então? Encontrou algo de estranho no sistema ontem?"
		},
		{
			"name": "Você",
			"text": "Pelo contrário. Seu 'pentest' abriu um backdoor. Alguém usou a sua máquina como ponte para entrar no sistema principal."
		},
		{
			"name": "Nathan",
			"text": "Isso é... impossível. Eu fechei todas as portas."
		},
		{
			"name": "Você",
			"text": "Pelo o que eu vi não fechou não... pedindo para IA analisar mais a fundo e identificar padrões."
		}
	],
	"interrogation_day3": [
		{
			"name": "Você",
			"text": "Leozin, precisamos falar sobre os pacotes suspeitos saindo do seu ambiente de desenvolvimento."
		},
		{
			"name": "Leozin",
			"text": "Do meu? Cara, eu só rodo código otimizado. Meu ambiente é impecável, zero bugs."
		},
		{
			"name": "Você",
			"text": "Então como você explica um minerador de criptomoeda e um script de exfiltração rodando em segundo plano no seu terminal?"
		},
		{
			"name": "Leozin",
			"text": "Espera... ontem eu baixei uma biblioteca que prometia compilar o código dez vezes mais rápido. Tava cheia de avaliação positiva no fórum!"
		},
		{
			"name": "Você",
			"text": "Você rodou código de terceiro sem auditar na rede do laboratório? Vou ter que isolar sua máquina agora mesmo."
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
			"text": "Remover o minerador foi fácil. O problema é que a biblioteca era um Cavalo de Troia. Ela abriu uma porta de entrada direto para a rede principal."
		},
		{
			"name": "Leozin",
			"text": "Puts... o Professor Ronisson vai acabar com minha nota. Fui tapeado por um repositório falso."
		},
		{
			"name": "Você",
			"text": "Esquece a nota por agora. O hacker conseguiu acesso de administrador usando sua máquina para escalar seu permissionamento. A situação ficou séria."
		}
	],
	"choice_intro": [
		{
			"name": "Prof. Ronisson",
			"text": "A situação saiu do controle. Analisamos todos os logs, interrogamos todos os suspeitos. Agora preciso de uma resposta: quem é o verdadeiro hacker por trás de tudo isso?"
		}
	]
}

static func get_dialogue(id: String) -> Array:
	if DATA.has(id):
		return DATA[id]
	push_error("Diálogo não encontrado no banco de dados: " + id)
	return []
