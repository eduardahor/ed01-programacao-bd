CREATE TABLE CLIENTE (
	CodigoCliente int identity PRIMARY KEY,
	Nome varchar(255),
	Email varchar(255),
	Celular varchar(20),
	PassHash varchar(255),
	MoedaPrincipal varchar(3),
	CONSTRAINT FK_MOEDAPRINCIPAL
	FOREIGN KEY (MoedaPrincipal) REFERENCES MOEDA (CodigoMoeda)
)

CREATE TABLE CARTEIRA (
	Endereco varchar(255) PRIMARY KEY,
	CodigoCorretora int 
		FOREIGN KEY REFERENCES CORRETORA (CodigoCorretora),	
	CodigoCliente int
		FOREIGN KEY REFERENCES CLIENTE (CodigoCliente)
)

CREATE TABLE MOEDA (
    CodigoMoeda VARCHAR(3),
    Nome VARCHAR(50)
    PRIMARY KEY (CodigoMoeda)
)

SELECT * FROM MOEDA

CREATE TABLE PARESMOEDAS (
COD_PAR INT IDENTITY PRIMARY KEY,
CodigoMoedaBase VARCHAR(3)
    FOREIGN KEY (CodigoMoedaBase) REFERENCES MOEDA(CodigoMoeda),
CodigoMoedaCotacao VARCHAR(3),
VALOR FLOAT 
)

SELECT * FROM PARESMOEDAS

CREATE TABLE CORRETORA (
    CodigoCorretora    INT IDENTITY PRIMARY KEY,
    NOME VARCHAR(255)
)

INSERT INTO MOEDACOTACAO(COTACAO) VALUES
    ('USD'),
    ('BRL')

SELECT * FROM MOEDA

DROP TABLE CORRETORA

INSERT INTO MOEDA VALUES
    ('BTC', 'BITCOIN')

INSERT INTO MOEDA VALUES
    ('LTC', 'LITECOIN')

INSERT INTO PARESMOEDAS (CodigoMoedaBase, CodigoMoedaCotacao, VALOR) 
VALUES 
    ('BTC', 'USD', 60356.70),
    ('ETH', 'USD', 2570.52),
    ('LTC', 'USD', 63.59)





