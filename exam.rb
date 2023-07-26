require 'pg'

class Exam
  attr_accessor :token, :exame_data, :cpf, :paciente_nome, :medico_nome, :resultado, :paciente_email, :paciente_data_nascimento, 
  :medico_crm, :medico_crm_estado, :exame_tipo, :exame_limites, :exame_resultado


  @db = PG.connect(host: 'db', user: 'myuser', password: 'password')

  class << self
    attr_reader :db
  end


  def initialize(token = '', exame_data = '', cpf = '', paciente_nome = '', medico_nome = '', 
                 resultado = '', paciente_email = '', paciente_data_nascimento = '', medico_crm = '', medico_crm_estado = '', 
                 exame_tipo = '', exame_limites = '', exame_resultado = '')
    @token = token
    @exame_data = exame_data
    @cpf = cpf
    @paciente_nome = paciente_nome
    @medico_nome = medico_nome
    @resultado = resultado
    @paciente_email = paciente_email
    @paciente_data_nascimento = paciente_data_nascimento
    @medico_crm = medico_crm
    @medico_crm_estado = medico_crm_estado
    @exame_tipo = exame_tipo
    @exame_limites = exame_limites
    @exame_resultado = exame_resultado
  end


  def self.all
    result = db.exec(
      'SELECT pacientes.cpf AS cpf, pacientes.nome AS paciente_nome, pacientes.email AS 
      paciente_email, pacientes.data_nascimento AS paciente_data_nascimento, pacientes.endereco AS 
      paciente_endereco, pacientes.cidade AS paciente_cidade, pacientes.estado AS paciente_estado, 
      medicos.crm AS medico_crm, medicos.estado_crm AS medico_crm_estado, medicos.nome AS medico_nome, medicos.email AS 
      medico_email, exames.token AS exame_token, exames.data AS exame_data, exames.tipo AS exame_tipo, exames.limites AS exame_limites, 
      exames.resultado AS exame_resultado FROM pacientes JOIN exames ON 
      exames.paciente_id = pacientes.id JOIN medicos ON medicos.id = exames.medico_id').to_a
  end

  def self.find_by_token(token)
    result = db.exec_params(
      'SELECT pacientes.cpf AS cpf, pacientes.nome AS paciente_nome, pacientes.email AS 
      paciente_email, pacientes.data_nascimento AS paciente_data_nascimento, pacientes.endereco AS 
      paciente_endereco, pacientes.cidade AS paciente_cidade, pacientes.estado AS paciente_estado, 
      medicos.crm AS medico_crm, medicos.estado_crm AS medico_crm_estado, medicos.nome AS medico_nome, medicos.email AS 
      medico_email, exames.token AS exame_token, exames.data AS exame_data, exames.tipo AS exame_tipo, exames.limites AS exame_limites, 
      exames.resultado AS exame_resultado FROM pacientes JOIN exames ON 
      exames.paciente_id = pacientes.id JOIN medicos ON medicos.id = exames.medico_id WHERE exames.token = $1', [token]).to_a

    result.first
  end

  def self.find_all_by_token(token)
    result = db.exec_params('SELECT * FROM exames WHERE token = $1', [token])
    result.map do |row|
      exam_hash = from_hash(row)
      exam = Exam.new(exam_hash)
      exam_hash
    end
  end

  def self.from_hash(hash)
    exam = {}
    exam[:token] = hash['token'] || ''
    exam[:exame_data] = hash['data']
    exam[:cpf] = hash['cpf'] || ''
    exam[:paciente_nome] = hash['paciente_nome'] || ''
    exam[:medico_nome] = hash['medico_nome'] || ''
    exam[:resultado] = hash['resultado'] || ''
    exam[:paciente_email] = hash['paciente_email'] || ''
    exam[:paciente_data_nascimento] = hash['paciente_data_nascimento'] || ''
    exam[:medico_crm] = hash['medico_crm'] || ''
    exam[:medico_crm_estado] = hash['medico_crm_estado'] || ''
    exam[:exame_tipo] = hash['tipo'] || ''
    exam[:exame_limites] = hash['limites'] || ''
    exam[:exame_resultado] = hash['resultado'] || ''
    exam
  end


end