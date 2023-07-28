require 'pg'
require 'csv'

class ImportFromCsv

  def initialize(csv_content)
    @csv_content = csv_content
    @conn_postgres = PG.connect(host: 'db', user: 'myuser', password: 'password')
    create_tables
  end

  def call
    rows = CSV.parse(@csv_content, col_sep: ';')
    columns = rows.shift
    rows.map! do |row|
      row.each_with_object({}).with_index do |(cell, acc), idx|
        column = columns[idx]
        acc[column] = cell
      end
    end

    rows.each do |row|
      paciente = paciente_find(row['cpf'])
      paciente_id = paciente.nil? ? insert_paciente(row) : paciente['id']

      medico = medico_find(row['crm médico'])
      medico_id = medico.nil? ? insert_medico(row) : medico['id']

      insert_exame(row, paciente_id, medico_id) if paciente_id && medico_id
    end
  end


  def create_tables
    @conn_postgres.exec("CREATE TABLE IF NOT EXISTS pacientes (
      id SERIAL PRIMARY KEY,
      cpf VARCHAR(30) UNIQUE,
      nome VARCHAR(100),
      email VARCHAR(100),
      data_nascimento DATE,
      endereco VARCHAR(200),
      cidade VARCHAR(100),
      estado VARCHAR(100)
    )")

    @conn_postgres.exec("CREATE TABLE IF NOT EXISTS medicos (
      id SERIAL PRIMARY KEY,
      crm VARCHAR(50) UNIQUE,
      estado_crm VARCHAR(100),
      nome VARCHAR(100),
      email VARCHAR(100)
    )")

    @conn_postgres.exec("CREATE TABLE IF NOT EXISTS exames (
      id SERIAL PRIMARY KEY,
      tipo VARCHAR(100),
      data DATE,
      limites VARCHAR(100),
      resultado VARCHAR(100),
      token VARCHAR(100),
      paciente_id INT REFERENCES pacientes(id),
      medico_id INT REFERENCES medicos(id),
      UNIQUE(tipo, data, token, paciente_id, medico_id)
    )")
  end

  private

  def insert_paciente(row)
    result = @conn_postgres.exec_params(
      'INSERT INTO pacientes (cpf, nome, email, data_nascimento, endereco, cidade, estado)
      VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT (cpf) DO NOTHING RETURNING id',
      [row['cpf'], row['nome paciente'], row['email paciente'],
       row['data nascimento paciente'], row['endereço/rua paciente'],
       row['cidade paciente'], row['estado patiente']]
    )
    result.first['id'] if result.any?
  end

  def insert_medico(row)
    result = @conn_postgres.exec_params(
      'INSERT INTO medicos (crm, estado_crm, nome, email) VALUES ($1, $2, $3, $4) ON CONFLICT (crm)
      DO NOTHING RETURNING id',
      [row['crm médico'], row['crm médico estado'], row['nome médico'], row['email médico']]
    )
    result.first['id'] if result.any?
  end

  def insert_exame(row, paciente_id, medico_id)
    @conn_postgres.exec_params(
      'INSERT INTO exames (tipo, data, limites, resultado, token, paciente_id, medico_id) 
      VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT (tipo, data, token, paciente_id, medico_id) DO NOTHING',
      [row['tipo exame'], row['data exame'], row['limites tipo exame'], row['resultado tipo exame'],
       row['token resultado exame'], paciente_id, medico_id]
      )
  end

  def paciente_find(cpf)
    result = @conn_postgres.exec_params('SELECT * FROM pacientes WHERE cpf = $1', [cpf])
    result[0] if result.num_tuples.positive?
  end

  def medico_find(crm)
    result = @conn_postgres.exec_params('SELECT * FROM medicos WHERE crm = $1', [crm])
    result[0] if result.num_tuples.positive?
  end
end