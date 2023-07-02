CREATE DATABASE mineradora_x; /* Criação do banco de dados da empresa x */

CREATE EXTENSION postgis;

CREATE USER admin_x WITH SUPERUSER PASSWORD 'password'; /* Criação do usuário mestre do banco */
GRANT ALL ON ALL TABLES IN SCHEMA "public" TO admin_x; /* Liberação de acesso e permissões */

CREATE TABLE campanha(
	id serial NOT NULL, /* Número da campanha de monitoramento */
    	data_inicio date NOT NULL,
	data_fim date,
	condicoes_climaticas text, /* Descrição textual das condições climáticas durante a campanha */
	CONSTRAINT pk_id_campanha PRIMARY KEY (id)
);

CREATE TABLE meio_amostrado(
	id serial NOT NULL,
	meio_amostrado varchar(50), /* Indica os meio amostrado e.g. solo, água, ar */
	CONSTRAINT pk_id_meio_amostrado PRIMARY KEY (id)	
);

CREATE TABLE campanha_meio_amostrado(
	id_campanha smallint NOT NULL,
	id_meio_amostrado smallint NOT NULL,
	CONSTRAINT fk_cma_campanha FOREIGN KEY (id_campanha) REFERENCES campanha (id),
	CONSTRAINT fk_cma_meio_amostrado FOREIGN KEY (id_meio_amostrado) REFERENCES meio_amostrado (id)
);

CREATE TABLE local_amostrado(
	id serial NOT NULL,
	meio_amostrado smallint NOT NULL,
	nome_ponto varchar(50) NOT NULL,
	localizacao geometry NOT NULL,
	autorizacao_acesso boolean,
	acompanhamento_acesso boolean,
	CONSTRAINT pk_id_locais_amostrados PRIMARY KEY (id),
	CONSTRAINT fk_meio_amostrado FOREIGN KEY (meio_amostrado) REFERENCES meio_amostrado (id)
);

CREATE TABLE responsavel_coleta(
	id serial NOT NULL,
	nome varchar(50),
	sobrenome varchar(50),
	terceirizado boolean,
	laboratorio varchar(50),
	CONSTRAINT pk_id_responsavel_coleta PRIMARY KEY (id)
);

CREATE TABLE resultados_agua(
	id serial NOT NULL,
	id_campanha smallint NOT NULL,
	id_local_amostrado smallint NOT NULL,
	id_responsavel_coleta smallint NOT NULL,
	data_amostragem timestamp NOT NULL,
	oxigenio_dissolvido numeric(8,2),
	col_termotolerantes int,
	ph numeric(2,2),
	dbo5 numeric(8,2),
	temperatura numeric(2,2),
	nitrogenio_total numeric(8,2),
	fosforo_total numeric(8,2),
	turbidez numeric(8,2),
	residuo_total numeric(8,2),
	iqa numeric(8,2), /* Pode ser automatizado criando-se uma função, uma view ou uma generated column */
	CONSTRAINT pk_id_resultados_agua PRIMARY KEY (id),
	CONSTRAINT fk_id_campanha FOREIGN KEY (id_campanha) REFERENCES campanha (id),
	CONSTRAINT fk_id_local_amostrado FOREIGN KEY (id_local_amostrado) REFERENCES local_amostrado (id),
	CONSTRAINT fk_id_responsavel_coleta FOREIGN KEY (id_responsavel_coleta) REFERENCES responsavel_coleta (id)
);

CREATE TABLE resultados_solos(
	id serial NOT NULL,
	id_campanha smallint NOT NULL,
	id_local_amostrado smallint NOT NULL,
	id_responsavel_coleta smallint NOT NULL,
	data_amostragem timestamp NOT NULL,
	acidez_total numeric(8,2),
	alumunio_total numeric(8,2),
	ph numeric(2,2),
	calcio numeric(8,2),
	magnesio numeric(8,2),
	ctc numeric(8,2),
	saturacao_bases numeric(3,2),
	teor_argila numeric(8,2),
	CONSTRAINT pk_id_resultados_solos PRIMARY KEY (id),
	CONSTRAINT fk_id_campanha FOREIGN KEY (id_campanha) REFERENCES campanha (id),
	CONSTRAINT fk_id_local_amostrado FOREIGN KEY (id_local_amostrado) REFERENCES local_amostrado (id),
	CONSTRAINT fk_id_responsavel_coleta FOREIGN KEY (id_responsavel_coleta) REFERENCES responsavel_coleta (id)
);

CREATE TABLE unidade_medida(
	id_campanha smallint NOT NULL,
	id_meio_amostrado smallint NOT NULL,
	unidade_medida jsonb, /* Pares de chaves e valores */
	CONSTRAINT fk_id_campanha FOREIGN KEY (id_campanha) REFERENCES campanha (id),
	CONSTRAINT fk_id_meio_amostrado FOREIGN KEY (id_meio_amostrado) REFERENCES meio_amostrado (id),
);