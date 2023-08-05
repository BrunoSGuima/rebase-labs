CREATE TABLE IF NOT EXISTS pacientes (
  id SERIAL PRIMARY KEY,
  cpf VARCHAR(30) UNIQUE,
  nome VARCHAR(100),
  email VARCHAR(100),
  data_nascimento DATE,
  endereco VARCHAR(200),
  cidade VARCHAR(100),
  estado VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS medicos (
  id SERIAL PRIMARY KEY,
  crm VARCHAR(50) UNIQUE,
  estado_crm VARCHAR(100),
  nome VARCHAR(100),
  email VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS exames (
  id SERIAL PRIMARY KEY,
  tipo VARCHAR(100),
  data DATE,
  limites VARCHAR(100),
  resultado VARCHAR(100),
  token VARCHAR(100),
  paciente_id INT REFERENCES pacientes(id),
  medico_id INT REFERENCES medicos(id),
  UNIQUE(tipo, data, token, paciente_id, medico_id)
);

