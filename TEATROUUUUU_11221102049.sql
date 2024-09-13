create schema teatro;
use teatro;

CREATE TABLE pecas_teatro (
    id_peca INT PRIMARY KEY AUTO_INCREMENT,
    nome_peca VARCHAR(100) NOT NULL,
    descricao TEXT,
    duracao INT,
    data_estreia DATETIME,
    diretor VARCHAR(100),
    elenco TEXT
);

DELIMITER $$

CREATE FUNCTION calcular_media_duracao(id_peca INT)
RETURNS FLOAT
BEGIN
    DECLARE media_duracao FLOAT;

    SELECT AVG(duracao) INTO media_duracao
    FROM pecas_teatro
    WHERE id_peca = id_peca;

    RETURN media_duracao;
END $$

DELIMITER ;


delimiter $$
CREATE FUNCTION verificar_disponibilidade(data_hora DATETIME)
RETURNS BOOLEAN
BEGIN
    DECLARE disponivel BOOLEAN;

    IF EXISTS (
        SELECT 1
        FROM pecas_teatro
        WHERE data_estreia = data_hora
    ) THEN
     
        SET disponivel = FALSE; -- Não disponível
    ELSE
                              
        SET disponivel = TRUE; -- Disponível
    END IF;

    RETURN disponivel;
END$$

delimiter ;



DELIMITER $$

CREATE PROCEDURE agendar_pecas(
    IN nome_peca VARCHAR(100),
    IN descricao TEXT,
    IN duracao INT,
    IN data_hora DATETIME,
    IN diretor VARCHAR(100),
    IN elenco TEXT
)
BEGIN
    DECLARE disponibilidade BOOLEAN;
    DECLARE media_duracao FLOAT;

    -- Verificar a disponibilidade
    SET disponibilidade = verificar_disponibilidade(data_hora);

    IF disponibilidade THEN
        -- Inserir a nova peça de teatro na tabela pecas_teatro
        INSERT INTO pecas_teatro (nome_peca, descricao, duracao, data_estreia, diretor, elenco)
        VALUES (nome_peca, descricao, duracao, data_hora, diretor, elenco);

        -- Calcular a média de duração usando a função calcular_media_duracao
        SET media_duracao = calcular_media_duracao(LAST_INSERT_ID());

        -- Imprimir informações sobre a peça agendada, incluindo a média de duração
        SELECT 
            nome_peca AS 'Nome da Peça',
            descricao AS 'Descrição',
            duracao AS 'Duração (minutos)',
            data_hora AS 'Data e Hora',
            diretor AS 'Diretor',
            elenco AS 'Elenco',
            media_duracao AS 'Média de Duração (minutos)'
        FROM pecas_teatro
        WHERE id_peca = LAST_INSERT_ID();
    ELSE
        SELECT 'A data e hora escolhidas já estão ocupadas. Por favor, escolha outro horário.' AS mensagem;
    END IF;
END $$

DELIMITER ;

INSERT INTO pecas_teatro (nome_peca, descricao, duracao, data_estreia, diretor, elenco)
VALUES 
('jalin rabei',
 'Uma tragédia escrita por jalambu canho sobre um jovem amante cuja morte é por ser amante.', 
 120, 
 '2024-09-15 19:00:00',
 'thomas lima', 
 'rodrio faro, Sthefanyy gimenez'),
 
  
('O Rei babão',
 'Uma peça de teatro sobre um rei que era desrrespeitoso, que mistura elementos de terror.',
 110,
 '2024-09-17 18:00:00', 
 'weberto rodriguez', 
 'Luiza sanchez, Julia maia'),
 
 
('O bruxo de Rivea',
 'Uma peça de teatro escrita por skellig thiss que explora um mundo sobre monstros na idade média.',
 130,
 '2024-09-18 21:00:00',
 'antonio montana',
 'Thom cruize, vladimir putin');


CALL agendar_pecas(
    'O Piscopata Americano',
    'Uma peça de teatro escrita por jonh Savini, sobre um homem de nova york que tem esquizofrenia e Psicopatia.',
    140,
    '2024-09-15 19:00:00', -- Data e hora já estão ocupadas por 'jalin rabei'
    'luciano ribeiro',
    'Abel Estevam, chris redenfild'
);


CALL agendar_pecas(
    'O lobo de whallstrit',
    'Uma peça de teatro de Woods sgrimn sobre o um homem que tem seus investimentos Subindo e Gastando o dinheiro em bebidas e drogas.',
    130,
    '2024-09-19 20:00:00', -- Data e horários disponíveis do teatro asmart
    'Giuberto pedroso',
    'Merly moroe, Roberto Carlos'
);


