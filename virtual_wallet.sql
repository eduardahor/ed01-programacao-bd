
-- Script de Criação - Carteira Virtual Criptomoedas
-- Disciplina: Programação em Banco de Dados
-- Universidade Tuiuti do Paraná - 2025/2
-- Alunos: Eduarda Horning Bzunek, João Gualberto Boissa Netto, José Otávio C. Raimundo e Yasmin dos Santos Pereira


-- Verificar se o banco de dados já existe e remover se necessário
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'CarteiraVirtualDB')
    DROP DATABASE CarteiraVirtualDB;
GO


-- 1. CRIAÇÃO DO BANCO DE DADOS

CREATE DATABASE CarteiraVirtualDB;
GO

-- Usar o banco de dados criado
USE CarteiraVirtualDB;
GO


-- 2. CRIAÇÃO DO ESQUEMA

CREATE SCHEMA Wallet AUTHORIZATION dbo;
GO


-- 3. CRIAÇÃO DAS TABELAS


-- Tabela de Clientes/Usuários
CREATE TABLE Wallet.Cliente (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    PassHash NVARCHAR(32) NOT NULL, -- MD5 hash da senha
    DataCadastro DATETIME2 DEFAULT SYSDATETIME(),
    Ativo BIT DEFAULT 1
);

-- Tabela de Moedas
CREATE TABLE Wallet.Moeda (
    MoedaID INT IDENTITY(1,1) PRIMARY KEY,
    NomeMoeda NVARCHAR(50) NOT NULL,
    SiglaAlgoritmo NVARCHAR(10) NOT NULL, -- Ex: BTC, ETH, LTC
    Descricao NVARCHAR(200),
    Ativo BIT DEFAULT 1
);

-- Tabela de Cotações
CREATE TABLE Wallet.Cotacao (
    CotacaoID INT IDENTITY(1,1) PRIMARY KEY,
    MoedaID INT NOT NULL,
    Par NVARCHAR(10) NOT NULL, -- Ex: BTC/USD, ETH/USD
    Preco DECIMAL(18,8) NOT NULL,
    DataCotacao DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (MoedaID) REFERENCES Wallet.Moeda(MoedaID)
);

-- Tabela da Carteira Virtual
CREATE TABLE Wallet.CarteiraVirtual (
    CarteiraID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT NOT NULL,
    MoedaID INT NOT NULL,
    EnderecoCarteira NVARCHAR(100) NOT NULL, -- Formato Base58
    Saldo DECIMAL(18,8) DEFAULT 0.00000000,
    DataCriacao DATETIME2 DEFAULT SYSDATETIME(),
    Ativo BIT DEFAULT 1,
    FOREIGN KEY (ClienteID) REFERENCES Wallet.Cliente(ClienteID),
    FOREIGN KEY (MoedaID) REFERENCES Wallet.Moeda(MoedaID),
    UNIQUE (ClienteID, MoedaID) -- Um cliente pode ter apenas uma carteira por moeda
);


-- 4. CRIAÇÃO DOS ÍNDICES


-- Índices para melhorar performance nas consultas mais frequentes
CREATE INDEX IX_Cliente_Email ON Wallet.Cliente(Email);
CREATE INDEX IX_Cotacao_MoedaID_DataCotacao ON Wallet.Cotacao(MoedaID, DataCotacao DESC);
CREATE INDEX IX_CarteiraVirtual_ClienteID ON Wallet.CarteiraVirtual(ClienteID);
CREATE INDEX IX_CarteiraVirtual_MoedaID ON Wallet.CarteiraVirtual(MoedaID);
CREATE INDEX IX_CarteiraVirtual_EnderecoCarteira ON Wallet.CarteiraVirtual(EnderecoCarteira);


-- 5. INSERÇÃO DE DADOS CONSISTENTES (POPULAR TABELAS)


-- Inserir Clientes
INSERT INTO Wallet.Cliente (Nome, Email, PassHash) VALUES
('João Silva', 'joao.silva@email.com', CONVERT(NVARCHAR(32), HASHBYTES('MD5', '123456'), 2)),
('Maria Santos', 'maria.santos@email.com', CONVERT(NVARCHAR(32), HASHBYTES('MD5', 'senha123'), 2)),
('Pedro Oliveira', 'pedro.oliveira@email.com', CONVERT(NVARCHAR(32), HASHBYTES('MD5', 'minhasenha'), 2)),
('Ana Costa', 'ana.costa@email.com', CONVERT(NVARCHAR(32), HASHBYTES('MD5', 'password'), 2));

-- Inserir Moedas
INSERT INTO Wallet.Moeda (NomeMoeda, SiglaAlgoritmo, Descricao) VALUES
('Bitcoin', 'BTC', 'A primeira e mais conhecida criptomoeda'),
('Ethereum', 'ETH', 'Plataforma descentralizada para contratos inteligentes'),
('Litecoin', 'LTC', 'Versão mais leve do Bitcoin com transações mais rápidas'),
('Cardano', 'ADA', 'Blockchain focada em sustentabilidade e pesquisa acadêmica'),
('Solana', 'SOL', 'Blockchain de alta performance para aplicações descentralizadas');

-- Inserir Cotações (baseadas nos exemplos fornecidos)
INSERT INTO Wallet.Cotacao (MoedaID, Par, Preco) VALUES
(1, 'BTC/USD', 60356.70),
(2, 'ETH/USD', 2570.52),
(3, 'LTC/USD', 63.59),
(4, 'ADA/USD', 0.45),
(5, 'SOL/USD', 145.78);

-- Inserir cotações históricas (para demonstrar variação)
INSERT INTO Wallet.Cotacao (MoedaID, Par, Preco, DataCotacao) VALUES
(1, 'BTC/USD', 58420.30, DATEADD(DAY, -1, SYSDATETIME())),
(2, 'ETH/USD', 2485.90, DATEADD(DAY, -1, SYSDATETIME())),
(3, 'LTC/USD', 61.25, DATEADD(DAY, -1, SYSDATETIME()));

-- Inserir Carteiras Virtuais com endereços Base58 simulados
INSERT INTO Wallet.CarteiraVirtual (ClienteID, MoedaID, EnderecoCarteira, Saldo) VALUES
(1, 1, '1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa', 0.15420000), -- João - Bitcoin
(1, 2, '0x742e4B3f2a1A1b2c3D4e5F6a7B8c9D0e1F2a3B4c', 2.50000000), -- João - Ethereum
(2, 1, '3QT1c5GxaqCnNvUusQsZ2jS6rWTRsNJSYp', 0.08750000), -- Maria - Bitcoin
(2, 3, 'LdP8Qox1VAhCzLJGufTMmTY2k8bj8RQjvX', 15.75000000), -- Maria - Litecoin
(3, 2, '0x8ba1f109551bD432803012645Hac136c22416CC8', 1.25000000), -- Pedro - Ethereum
(3, 4, 'addr1q8j9k0l1m2n3o4p5q6r7s8t9u0v1w2x3y4z5a6b7c8d9e0f', 1500.00000000), -- Pedro - Cardano
(4, 5, '7xKWvQhB9X2YtJZrNm8V3LkQ5RsT6PdGn4HcF9Wi2E8U', 5.25000000); -- Ana - Solana


-- 6. CRIAÇÃO DE VISÃO PARA FACILITAR CONSULTAS


GO
-- Visão para mostrar saldo atual por usuário com descrição da moeda
CREATE VIEW Wallet.VW_SaldoUsuario AS
SELECT 
    c.ClienteID,
    c.Nome AS NomeCliente,
    c.Email,
    m.NomeMoeda,
    m.SiglaAlgoritmo,
    cv.EnderecoCarteira,
    cv.Saldo,
    cot.Preco AS UltimaCotacao,
    (cv.Saldo * cot.Preco) AS ValorEmUSD,
    cv.DataCriacao AS DataCriacaoCarteira
FROM Wallet.Cliente c
INNER JOIN Wallet.CarteiraVirtual cv ON c.ClienteID = cv.ClienteID
INNER JOIN Wallet.Moeda m ON cv.MoedaID = m.MoedaID
OUTER APPLY (
    -- Buscar a cotação mais recente para cada moeda
    SELECT TOP 1 Preco 
    FROM Wallet.Cotacao cot 
    WHERE cot.MoedaID = m.MoedaID 
    ORDER BY DataCotacao DESC
) cot
WHERE c.Ativo = 1 AND cv.Ativo = 1 AND m.Ativo = 1;
GO


-- 7. LISTAGEM DOS DADOS INSERIDOS


PRINT '=====================================================';
PRINT '7. LISTAGEM DOS DADOS INSERIDOS';
PRINT '=====================================================';

-- Listar Clientes
PRINT 'CLIENTES CADASTRADOS:';
SELECT ClienteID, Nome, Email, PassHash, DataCadastro, Ativo 
FROM Wallet.Cliente;

PRINT CHAR(13) + CHAR(10) + 'MOEDAS CADASTRADAS:';
SELECT MoedaID, NomeMoeda, SiglaAlgoritmo, Descricao, Ativo 
FROM Wallet.Moeda;

PRINT CHAR(13) + CHAR(10) + 'COTAÇÕES ATUAIS:';
SELECT c.CotacaoID, m.NomeMoeda, c.Par, c.Preco, c.DataCotacao 
FROM Wallet.Cotacao c
INNER JOIN Wallet.Moeda m ON c.MoedaID = m.MoedaID
ORDER BY c.DataCotacao DESC;

PRINT CHAR(13) + CHAR(10) + 'CARTEIRAS VIRTUAIS:';
SELECT cv.CarteiraID, c.Nome, m.NomeMoeda, cv.EnderecoCarteira, cv.Saldo, cv.DataCriacao 
FROM Wallet.CarteiraVirtual cv
INNER JOIN Wallet.Cliente c ON cv.ClienteID = c.ClienteID
INNER JOIN Wallet.Moeda m ON cv.MoedaID = m.MoedaID;


-- 8. CONSULTA PRINCIPAL: SALDO ATUAL POR USUÁRIO


PRINT CHAR(13) + CHAR(10) + '=====================================================';
PRINT 'SALDO ATUAL POR USUÁRIO (USANDO VISÃO):';
PRINT '=====================================================';

SELECT 
    NomeCliente,
    Email,
    NomeMoeda,
    SiglaAlgoritmo,
    EnderecoCarteira,
    Saldo,
    UltimaCotacao,
    ROUND(ValorEmUSD, 2) AS ValorEmUSD,
    DataCriacaoCarteira
FROM Wallet.VW_SaldoUsuario
ORDER BY NomeCliente, NomeMoeda;


-- 9. CONSULTAS ADICIONAIS ÚTEIS


PRINT CHAR(13) + CHAR(10) + 'RESUMO TOTAL POR CLIENTE:';
SELECT 
    NomeCliente,
    COUNT(*) AS QtdCarteiras,
    SUM(ValorEmUSD) AS ValorTotalUSD
FROM Wallet.VW_SaldoUsuario
GROUP BY ClienteID, NomeCliente
ORDER BY ValorTotalUSD DESC;

PRINT CHAR(13) + CHAR(10) + 'SCRIPT DE CRIAÇÃO EXECUTADO COM SUCESSO!';
PRINT 'Banco de dados CarteiraVirtualDB criado e populado.';
GO