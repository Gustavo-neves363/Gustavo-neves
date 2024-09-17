CREATE SCHEMA veterinario;
USE veterinario;

CREATE TABLE Pacientes (
  id_paciente INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(100),
  especie VARCHAR(50),
  idade INT
);

CREATE TABLE Veterinários (
  id_veterinario INT PRIMARY KEY AUTO_INCREMENT,
  nome VARCHAR(100),
  especialidade VARCHAR(50)
);

CREATE TABLE Consultas (
  id_consulta INT PRIMARY KEY AUTO_INCREMENT,
  id_paciente INT,
  id_veterinario INT,
  data_consulta DATE,
  custo DECIMAL(10, 2),
  FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
  FOREIGN KEY (id_veterinario) REFERENCES Veterinários(id_veterinario)
);

DELIMITER //
CREATE PROCEDURE agendar_consulta(
  IN id_paciente INT,
  IN id_veterinario INT,
  IN data_consulta DATE,
  IN custo DECIMAL(10, 2)
)
BEGIN
  INSERT INTO Consultas (id_paciente, id_veterinario, data_consulta, custo)
  VALUES (id_paciente, id_veterinario, data_consulta, custo);
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE atualizar_paciente(
  IN id_paciente INT,
  IN novo_nome VARCHAR(100),
  IN nova_especie VARCHAR(50),
  IN nova_idade INT
)
BEGIN
  UPDATE Pacientes
  SET nome = novo_nome, especie = nova_especie, idade = nova_idade
  WHERE id_paciente = id_paciente;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE remover_consulta(
  IN id_consulta INT
)
BEGIN
  DELETE FROM Consultas
  WHERE id_consulta = id_consulta;
END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION total_gasto_paciente(id_paciente INT)
RETURNS DECIMAL(10, 2)
BEGIN
  DECLARE total_gasto DECIMAL(10, 2);
  SELECT SUM(custo) INTO total_gasto
  FROM Consultas
  WHERE id_paciente = id_paciente;
  RETURN total_gasto;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER verificar_idade_paciente
BEFORE INSERT ON Pacientes
FOR EACH ROW
BEGIN
  IF NEW.idade <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Idade do paciente deve ser um número positivo.';
  END IF;
END//
DELIMITER ;

CREATE TABLE Log_Consultas (
  id_log INT PRIMARY KEY AUTO_INCREMENT,
  id_consulta INT,
  custo_antigo DECIMAL(10, 2),
  custo_novo DECIMAL(10, 2)
);

DELIMITER //
CREATE TRIGGER atualizar_custo_consulta
AFTER UPDATE ON Consultas
FOR EACH ROW
BEGIN
  IF NEW.custo != OLD.custo THEN
    INSERT INTO Log_Consultas (id_consulta, custo_antigo, custo_novo)
    VALUES (NEW.id_consulta, OLD.custo, NEW.custo);
  END IF;
END//
DELIMITER ;

