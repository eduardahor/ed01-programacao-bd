-- =====================================================
-- Script de Rollback - Carteira Virtual Criptomoedas
-- Disciplina: PI Programação em Banco de Dados
-- Universidade Tuiuti do Paraná - 2025/2
-- =====================================================

USE CarteiraVirtualDB;
GO

PRINT '=====================================================';
PRINT 'INICIANDO ROLLBACK DO BANCO DE DADOS';
PRINT 'Removendo objetos na ordem correta para manter integridade referencial';
PRINT '=====================================================';

-- =====================================================
-- 1. REMOÇÃO DA VISÃO
-- =====================================================
IF EXISTS (SELECT * FROM sys.views WHERE name = 'VW_SaldoUsuario' AND schema_id = SCHEMA_ID('Wallet'))
BEGIN
    DROP VIEW Wallet.VW_SaldoUsuario;
    PRINT '✓ Visão VW_SaldoUsuario removida com sucesso';
END
ELSE
    PRINT '⚠ Visão VW_SaldoUsuario não encontrada';

-- =====================================================
-- 2. REMOÇÃO DOS ÍNDICES
-- =====================================================

-- Remover índices da tabela CarteiraVirtual
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CarteiraVirtual_ClienteID')
BEGIN
    DROP INDEX IX_CarteiraVirtual_ClienteID ON Wallet.CarteiraVirtual;
    PRINT '✓ Índice IX_CarteiraVirtual_ClienteID removido';
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CarteiraVirtual_MoedaID')
BEGIN
    DROP INDEX IX_CarteiraVirtual_MoedaID ON Wallet.CarteiraVirtual;
    PRINT '✓ Índice IX_CarteiraVirtual_MoedaID removido';
END

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CarteiraVirtual_EnderecoCarteira')
BEGIN
    DROP INDEX IX_CarteiraVirtual_EnderecoCarteira ON Wallet.CarteiraVirtual;
    PRINT '✓ Índice IX_CarteiraVirtual_EnderecoCarteira removido';
END

-- Remover índices da tabela Cotacao
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Cotacao_MoedaID_DataCotacao')
BEGIN
    DROP INDEX IX_Cotacao_MoedaID_DataCotacao ON Wallet.Cotacao;
    PRINT '✓ Índice IX_Cotacao_MoedaID_DataCotacao removido';
END

-- Remover índices da tabela Cliente
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Cliente_Email')
BEGIN
    DROP INDEX IX_Cliente_Email ON Wallet.Cliente;
    PRINT '✓ Índice IX_Cliente_Email removido';
END

-- =====================================================
-- 3. REMOÇÃO DAS TABELAS (ORDEM CORRETA DE DEPENDÊNCIAS)
-- =====================================================

-- 3.1 Remover tabela CarteiraVirtual (dependente de Cliente e Moeda)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'CarteiraVirtual' AND schema_id = SCHEMA_ID('Wallet'))
BEGIN
    DROP TABLE Wallet.CarteiraVirtual;
    PRINT '✓ Tabela CarteiraVirtual removida com sucesso';
END
ELSE
    PRINT '⚠ Tabela CarteiraVirtual não encontrada';

-- 3.2 Remover tabela Cotacao (dependente de Moeda)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Cotacao' AND schema_id = SCHEMA_ID('Wallet'))
BEGIN
    DROP TABLE Wallet.Cotacao;
    PRINT '✓ Tabela Cotacao removida com sucesso';
END
ELSE
    PRINT '⚠ Tabela Cotacao não encontrada';

-- 3.3 Remover tabela Cliente (sem dependências)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Cliente' AND schema_id = SCHEMA_ID('Wallet'))
BEGIN
    DROP TABLE Wallet.Cliente;
    PRINT '✓ Tabela Cliente removida com sucesso';
END
ELSE
    PRINT '⚠ Tabela Cliente não encontrada';

-- 3.4 Remover tabela Moeda (sem dependências)
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Moeda' AND schema_id = SCHEMA_ID('Wallet'))
BEGIN
    DROP TABLE Wallet.Moeda;
    PRINT '✓ Tabela Moeda removida com sucesso';
END
ELSE
    PRINT '⚠ Tabela Moeda não encontrada';

-- =====================================================
-- 4. REMOÇÃO DO ESQUEMA
-- =====================================================
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'Wallet')
BEGIN
    DROP SCHEMA Wallet;
    PRINT '✓ Esquema Wallet removido com sucesso';
END
ELSE
    PRINT '⚠ Esquema Wallet não encontrado';

-- =====================================================
-- 5. VERIFICAÇÃO FINAL
-- =====================================================
PRINT CHAR(13) + CHAR(10) + '=====================================================';
PRINT 'VERIFICAÇÃO FINAL - OBJETOS REMANESCENTES:';
PRINT '=====================================================';

-- Verificar se ainda existem objetos do esquema Wallet
DECLARE @ObjetosRemanescentes INT = 0;

SELECT @ObjetosRemanescentes = COUNT(*)
FROM sys.objects o
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE s.name = 'Wallet';

IF @ObjetosRemanescentes > 0
BEGIN
    PRINT '⚠ ATENÇÃO: Ainda existem ' + CAST(@ObjetosRemanescentes AS VARCHAR(10)) + ' objeto(s) no esquema Wallet';
    
    -- Listar objetos remanescentes
    SELECT 
        s.name AS Schema_Name,
        o.name AS Object_Name,
        o.type_desc AS Object_Type
    FROM sys.objects o
    INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
    WHERE s.name = 'Wallet';
END
ELSE
    PRINT '✓ Nenhum objeto remanescente encontrado no esquema Wallet';

-- Verificar se o esquema ainda existe
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'Wallet')
    PRINT '⚠ ATENÇÃO: Esquema Wallet ainda existe';
ELSE
    PRINT '✓ Esquema Wallet removido completamente';

PRINT CHAR(13) + CHAR(10) + '=====================================================';
PRINT 'ROLLBACK CONCLUÍDO!';
PRINT 'Todos os objetos foram removidos do banco CarteiraVirtualDB';
PRINT 'O banco de dados permanece, mas está vazio dos objetos criados.';
PRINT '=====================================================';

-- =====================================================
-- 6. REMOÇÃO COMPLETA DO BANCO DE DADOS (OPCIONAL)
-- =====================================================
-- DESCOMENTE AS LINHAS ABAIXO SE DESEJAR REMOVER COMPLETAMENTE O BANCO

/*
USE master;
GO

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'CarteiraVirtualDB')
BEGIN
    -- Forçar desconexão de usuários
    ALTER DATABASE CarteiraVirtualDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CarteiraVirtualDB;
    PRINT '✓ Banco de dados CarteiraVirtualDB removido completamente';
END
ELSE
    PRINT '⚠ Banco de dados CarteiraVirtualDB não encontrado';
*/

GO
