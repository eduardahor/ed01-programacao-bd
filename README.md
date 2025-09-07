# Carteira Virtual de Criptomoedas
Este repositório contém o estudo dirigido para a disciplina de Programação de Banco de Dados do 4º semestre na Universidade Tuiuti do Paraná. O objetivo principal é a criação de um banco de dados relacional para gerenciar uma carteira virtual de criptomoedas.
O projeto demonstra a criação e manipulação de um banco de dados, incluindo a modelagem de tabelas, a inserção de dados consistentes e a criação de consultas e visões para análise.

# 📁 Estrutura do Projeto
O repositório é composto por um único arquivo SQL que executa todas as etapas do projeto:
virtual_wallet.sql: Script completo para criar e popular o banco de dados.

# 🚀 Como Executar o Script
+ Para utilizar este projeto, siga os passos abaixo:
+ Abra o arquivo virtual_wallet.sql em uma ferramenta de gerenciamento de banco de dados, como o SQL Server Management Studio (SSMS).
+ Conecte-se a uma instância do SQL Server.
  
# Execute o script. Ele irá:
+ Remover o banco de dados CarteiraVirtualDB se ele já existir.
+ Criar o banco de dados e o esquema Wallet.
+ Criar todas as tabelas: Cliente, Moeda, Cotacao, CarteiraVirtual.
+ Inserir dados de exemplo para popular as tabelas.
+ Criar índices para otimizar o desempenho das consultas.
+ Criar uma visão (VW_SaldoUsuario) para facilitar a consulta de saldos.
+ Executar consultas de listagem e análise para demonstrar o funcionamento do sistema.

# 📊 Modelagem do Banco de Dados
O banco de dados foi projetado com as seguintes tabelas e relacionamentos:

+ Cliente: Armazena informações dos usuários.
+ Moeda: Lista as criptomoedas suportadas.
+ Cotacao: Registra o preço das moedas.
+ CarteiraVirtual: Vincula os clientes às moedas, registrando o saldo e o endereço da carteira.

# 📈 Análises e Consultas
O script inclui consultas prontas que permitem:

+ Listar todos os clientes, moedas e cotações.
+ Visualizar o saldo de cada cliente, mostrando o valor de sua carteira em dólar (USD).
+ Obter um resumo total do valor de todas as carteiras por cliente.

# 👨‍💻 Colaboradores
+ Nome do Aluno: Eduarda Horning Bzunek, João Gualberto Boissa Netto, José Otávio C. Raimundo e Yasmin dos Santos Pereira
+ Matéria: Programação em Banco de Dados
+ Período: 4º Semestre - 2025/2
+ Instituição: Universidade Tuiuti do Paraná
