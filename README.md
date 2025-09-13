# Sistema de Carteira Virtual para Criptomoedas

![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

Sistema de banco de dados para gerenciamento de carteiras virtuais de criptomoedas desenvolvido como projeto acadêmico da disciplina **Programação em Banco de Dados** da **Universidade Tuiuti do Paraná**.

## 👥 Equipe de Desenvolvimento

- **Eduarda Horning Bzunek**
- **João Gualberto Boissa Netto** 
- **José Otávio C. Raimundo**
- **Yasmin dos Santos Pereira**

## 📋 Descrição do Projeto

O projeto consiste na criação de um sistema de banco de dados relacional para uma aplicação de carteira virtual de criptomoedas, implementando funcionalidades de:

- ✅ **Manutenção de Clientes/Usuários** - Cadastro e gerenciamento de usuários
- ✅ **Manutenção de Moedas** - Registro das criptomoedas disponíveis  
- ✅ **Manutenção de Cotações** - Controle de preços e histórico
- ✅ **Manutenção de Carteiras Virtuais** - Gerenciamento de saldos e endereços

## 🏗️ Arquitetura do Banco de Dados

### Esquema Conceitual

```
Cliente (1) ----< (N) CarteiraVirtual (N) >---- (1) Moeda
                                                  |
                                                  |
                                              (1) |
                                                  |
                                                  v
                                               Cotacao (N)
```

### Tabelas Principais

| Tabela | Descrição | Características |
|--------|-----------|-----------------|
| `Wallet.Cliente` | Dados dos usuários | Hash MD5 para senhas, controle de ativação |
| `Wallet.Moeda` | Criptomoedas disponíveis | Bitcoin, Ethereum, Litecoin, etc. |
| `Wallet.Cotacao` | Preços e histórico | Cotações em tempo real e históricas |
| `Wallet.CarteiraVirtual` | Carteiras dos usuários | Endereços Base58, saldos precisos |

## 🚀 Como Executar

### Pré-requisitos

- Microsoft SQL Server 2016+ 
- SQL Server Management Studio (SSMS)
- Permissões para criação de banco de dados

### Instalação

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/seu-usuario/carteira-virtual-crypto.git
   cd carteira-virtual-crypto
   ```

2. **Execute o script de criação:**
   - Abra o SSMS
   - Conecte ao servidor SQL Server
   - Abra o arquivo `script_criacao_carteira_virtual.sql`
   - Execute o script completo (F5)

3. **Verificação:**
   - O script criará o banco `CarteiraVirtualDB`
   - Populará as tabelas com dados de exemplo
   - Exibirá relatórios de verificação

### Rollback (Desfazer)

Para remover completamente o banco e suas estruturas:

1. Execute o arquivo `script_rollback_carteira_virtual.sql`
2. O script remove todos os objetos na ordem correta de dependências

## 📁 Estrutura dos Arquivos

```
carteira-virtual-crypto/
├── README.md                                 # Este arquivo
├── DOCUMENTATION.md                          # Documentação técnica completa
├── script_criacao_carteira_virtual.sql      # Script principal de criação
├── script_rollback_carteira_virtual.sql     # Script de reversão
└── docs/
    ├── diagrama_er.png                      # Diagrama entidade-relacionamento
    └── modelo_conceitual.png                # Modelo conceitual
```

## 🔧 Funcionalidades Implementadas

### Segurança
- **Hashing MD5** para senhas usando `HASHBYTES()`
- **Esquema dedicado** (`Wallet`) para organização
- **Chaves estrangeiras** para integridade referencial

### Performance  
- **Índices estratégicos** nas colunas mais consultadas
- **Visão otimizada** (`VW_SaldoUsuario`) para consultas complexas
- **Tipos de dados precisos** (`DECIMAL(18,8)`) para valores monetários

### Relatórios
- Saldo atual por usuário com valor em USD
- Resumo total por cliente
- Histórico de cotações
- Listagem completa de carteiras

## 📊 Dados de Exemplo

O sistema vem pré-populado com:
- **4 usuários** de exemplo
- **5 criptomoedas** (Bitcoin, Ethereum, Litecoin, Cardano, Solana)  
- **Cotações atuais** e históricas
- **7 carteiras virtuais** com saldos realistas

## 🔍 Consultas Principais

### Saldo por Usuário
```sql
SELECT * FROM Wallet.VW_SaldoUsuario 
ORDER BY NomeCliente, NomeMoeda;
```

### Resumo Financeiro
```sql
SELECT 
    NomeCliente,
    COUNT(*) AS QtdCarteiras,
    SUM(ValorEmUSD) AS ValorTotalUSD
FROM Wallet.VW_SaldoUsuario
GROUP BY ClienteID, NomeCliente
ORDER BY ValorTotalUSD DESC;
```

## 🎓 Contexto Acadêmico

**Disciplina:** Programação em Banco de Dados  
**Semestre:** 2025/2  
**Professor:** SERGIO LUIZ MARQUES FILHO  
**Instituição:** Universidade Tuiuti do Paraná  
**Curso:** Tecnologia em Análise de Sistemas

## 📝 Especificações Técnicas

- **SGBD:** Microsoft SQL Server
- **Linguagem:** T-SQL (Transact-SQL)
- **Encoding:** UTF-8 com suporte a caracteres especiais
- **Precisão Decimal:** 18 dígitos, 8 casas decimais para criptomoedas
- **Formato de Endereços:** Base58 (padrão blockchain)
