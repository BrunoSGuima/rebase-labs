require 'pg'
require 'csv'

$conn_postgres = PG.connect(host: 'db', user: 'myuser', password: 'password')

$conn_postgres.exec("CREATE TABLE IF NOT EXISTS pacientes (
  id SERIAL PRIMARY KEY,
  cpf VARCHAR(30),
  nome VARCHAR(100),
  email VARCHAR(100),
  data_nascimento DATE,
  endereco VARCHAR(200),
  cidade VARCHAR(100),
  estado VARCHAR(100)
)")

$conn_postgres.exec("CREATE TABLE IF NOT EXISTS medicos (
  id SERIAL PRIMARY KEY,
  crm VARCHAR(50),
  estado_crm VARCHAR(100),
  nome VARCHAR(100),
  email VARCHAR(100)
)")

$conn_postgres.exec("CREATE TABLE IF NOT EXISTS exames (
  id SERIAL PRIMARY KEY,
  tipo VARCHAR(100),
  data DATE,
  limites VARCHAR(100),
  resultado VARCHAR(100),
  token VARCHAR(100),
  paciente_id INT REFERENCES pacientes(id),
  medico_id INT REFERENCES medicos(id)
)")

def insert_paciente(row)
  $conn_postgres.exec_params(
    'INSERT INTO pacientes (cpf, nome, email, data_nascimento, endereco, cidade, estado) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id',
    [row['cpf'], row['nome paciente'], row['email paciente'], row['data nascimento paciente'], row['endereço/rua paciente'], row['cidade paciente'], row['estado patiente']]
  )
end

def insert_medico(row)
  $conn_postgres.exec_params(
    'INSERT INTO medicos (crm, estado_crm, nome, email) VALUES ($1, $2, $3, $4) RETURNING id',
    [row['crm médico'], row['crm médico estado'], row['nome médico'], row['email médico']]
  )
end

def insert_exame(row, paciente_id, medico_id)
  $conn_postgres.exec_params(
    'INSERT INTO exames (tipo, data, limites, resultado, token, paciente_id, medico_id) VALUES ($1, $2, $3, $4, $5, $6, $7)',
    [row['tipo exame'], row['data exame'], row['limites tipo exame'], row['resultado tipo exame'], row['token resultado exame'], paciente_id, medico_id]
  )
end

rows = CSV.read("./data.csv", col_sep: ';')
columns = rows.shift
rows.map! do |row|
  row.each_with_object({}).with_index do |(cell, acc), idx|
    column = columns[idx]
    acc[column] = cell
  end
end

def paciente_find(cpf)
  result = $conn_postgres.exec_params('SELECT * FROM pacientes WHERE cpf = $1', [cpf])
  result[0] if result.num_tuples > 0
end

def medico_find(crm)
  result = $conn_postgres.exec_params('SELECT * FROM medicos WHERE crm = $1', [crm])
  result[0] if result.num_tuples > 0
end

rows.each do |row|
  begin
    paciente = paciente_find(row['cpf'])
    paciente_id = nil

    if paciente.nil?
      paciente_result = insert_paciente(row)
      paciente_id = paciente_result.getvalue(0, 0) if paciente_result.num_tuples > 0
    else
      paciente_id = paciente['id']
    end

    medico = medico_find(row['crm médico'])
    medico_id = nil

    if medico.nil?
      medico_result = insert_medico(row)
      medico_id = medico_result.getvalue(0, 0) if medico_result.num_tuples > 0
    else
      medico_id = medico['id']
    end

    insert_exame(row, paciente_id, medico_id) if paciente_id && medico_id
  rescue PG::UniqueViolation => e
    next
  end
end
